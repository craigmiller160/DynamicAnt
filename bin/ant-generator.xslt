<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:template match="/project">
		<xsl:variable name="userHome">
			<xsl:text>/Users/craigmiller</xsl:text>
		</xsl:variable>
		<!-- This devRoot variable is platform-dependent. It is the parent directory of any dev directories -->
		<xsl:variable name="devRoot">
			<xsl:value-of select="concat($userHome,'/PilotFish/DevRoot')" />
		</xsl:variable>
		<!-- This devMain variable is platform-dependent. It is full the path to the Main development directory within devRoot. This is the default development directory -->
		<xsl:variable name="devMain">
			<xsl:value-of select="concat($devRoot,'/Main')" />
		</xsl:variable>
		<xsl:variable name="projectName" select="@name" />
		<xsl:variable name="projectVersion" select="@version" />
		<project default="jar">
			<xsl:attribute name="name">
				<xsl:value-of select="$projectName" />
			</xsl:attribute>
			<property name="project.company" value="PilotFish" />
			<property name="project.name">
				<xsl:attribute name="value">
					<xsl:value-of select="$projectName" />
				</xsl:attribute>
			</property>
			<property name="project.version">
				<xsl:attribute name="value">
					<xsl:value-of select="$projectVersion" />
				</xsl:attribute>
			</property>
			<property name="project.author">
				<xsl:attribute name="value">
					<xsl:choose>
						<xsl:when test="author/@name">
							<xsl:value-of select="author/@name" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>PilotFish Developer</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</property>
			<property name="dir.dev">
				<xsl:attribute name="value">
					<xsl:choose>
						<xsl:when test="dev/@dir">
							<xsl:value-of select="concat($devRoot,'/',dev/@dir)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$devMain" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</property>
			<property name="dir.dev.src">
				<xsl:attribute name="value">
					<xsl:text>${dir.dev}/src</xsl:text>
				</xsl:attribute>
			</property>
			<property name="dir.dev.subprojects">
				<xsl:attribute name="value">
					<xsl:text>${dir.dev}/subprojects</xsl:text>
				</xsl:attribute>
			</property>
			<property name="dir.dev.out">
				<xsl:attribute name="value">
					<!-- TODO The last element in this path is not platform-independent -->
					<xsl:text>${dir.dev}/out/production/PilotFish</xsl:text>
				</xsl:attribute>
			</property>
			<property name="dir.project">
				<xsl:attribute name="value">
					<xsl:value-of select="concat($userHome,'/',$projectName)" />
				</xsl:attribute>
			</property>
			<property name="dir.project.build">
				<xsl:attribute name="value">
					<xsl:text>${dir.project}/build</xsl:text>
				</xsl:attribute>
			</property>
			<property name="dir.project.build.sources">
				<xsl:attribute name="value">
					<xsl:text>${dir.project.build}/sources</xsl:text>
				</xsl:attribute>
			</property>
			<target name="clean">
				<delete>
					<xsl:attribute name="dir">
						<xsl:text>${dir.project}</xsl:text>
					</xsl:attribute>
				</delete>
			</target>
			<target depends="clean" name="prepare">
				<mkdir>
					<xsl:attribute name="dir">
						<xsl:text>${dir.project.build.sources}</xsl:text>
					</xsl:attribute>
				</mkdir>
				<xsl:for-each select="files/src/file">
					<mkdir>
						<xsl:attribute name="dir">
							<xsl:value-of select="concat('${dir.project.build}/',@pkg)" />
						</xsl:attribute>
					</mkdir>
					<mkdir>
						<xsl:attribute name="dir">
							<xsl:value-of select="concat('${dir.project.build.sources}/',@pkg)" />
						</xsl:attribute>
					</mkdir>
				</xsl:for-each>
				<xsl:for-each select="files/subprojects/file">
					<mkdir>
						<xsl:attribute name="dir">
							<xsl:value-of select="concat('${dir.project.build}/',@pkg)" />
						</xsl:attribute>
					</mkdir>
					<mkdir>
						<xsl:attribute name="dir">
							<xsl:value-of select="concat('${dir.project.build.sources}/',@pkg)" />
						</xsl:attribute>
					</mkdir>
				</xsl:for-each>
			</target>
			<target depends="prepare" name="copy">
				<xsl:for-each select="files/src/file">
					<copy>
						<xsl:attribute name="todir">
							<xsl:value-of select="concat('${dir.project.build.sources}/',@pkg)" />
						</xsl:attribute>
						<xsl:attribute name="file">
							<xsl:value-of select="concat('${dir.dev.src}/',@pkg,'/',@name,'.java')" />
						</xsl:attribute>
					</copy>
					<copy>
						<xsl:attribute name="todir">
							<xsl:value-of select="concat('${dir.project.build}/',@pkg)" />
						</xsl:attribute>
						<fileset>
							<xsl:attribute name="dir">
								<xsl:value-of select="concat('${dir.dev.out}/',@pkg)" />
							</xsl:attribute>
							<xsl:attribute name="includes">
								<xsl:value-of select="concat(@name,'*.class')" />
							</xsl:attribute>
						</fileset>
					</copy>
				</xsl:for-each>
				<xsl:for-each select="files/subprojects">
					<xsl:variable name="subprojectName" select="@name" />
					<xsl:for-each select="file">
						<copy>
							<xsl:attribute name="todir">
								<xsl:value-of select="concat('${dir.project.build.sources}/',@pkg)" />
							</xsl:attribute>
							<xsl:attribute name="file">
								<xsl:value-of select="concat('${dir.dev.src}/',@pkg,'/',@name,'.java')" />
							</xsl:attribute>
						</copy>
						<copy>
							<xsl:attribute name="todir">
								<xsl:value-of select="concat('${dir.project.build}/',@pkg)" />
							</xsl:attribute>
							<fileset>
								<xsl:attribute name="dir">
									<xsl:value-of select="concat('${dir.dev.out}/',$subprojectName,'/',@pkg)" />
								</xsl:attribute>
								<xsl:attribute name="includes">
									<xsl:value-of select="concat(@name,'*.class')" />
								</xsl:attribute>
							</fileset>
						</copy>
					</xsl:for-each>
				</xsl:for-each>
			</target>
			<target name="jar-only">
				<delete>
					<fileset includes="*.jar">
						<xsl:attribute name="dir">
							<xsl:text>${dir.project}</xsl:text>
						</xsl:attribute>
					</fileset>
				</delete>
				<jar>
					<xsl:attribute name="destfile">
						<xsl:text>${dir.project}/${project.name}-${project.version}.jar</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="basedir">
						<xsl:text>${dir.project.build}</xsl:text>
					</xsl:attribute>
					<manifest>
						<attribute name="Title">
							<xsl:attribute name="value">
								<xsl:text>${project.name}</xsl:text>
							</xsl:attribute>
						</attribute>
						<attribute name="Company">
							<xsl:attribute name="value">
								<xsl:text>${project.company}</xsl:text>
							</xsl:attribute>
						</attribute>
						<attribute name="Built-By">
							<xsl:attribute name="value">
								<xsl:text>${project.author}</xsl:text>
							</xsl:attribute>
						</attribute>
						<attribute name="Version">
							<xsl:attribute name="value">
								<xsl:text>${project.version}</xsl:text>
							</xsl:attribute>
						</attribute>
					</manifest>
				</jar>
			</target>
			<target depends="copy" name="jar">
				<antcall target="jar-only" />
			</target>
		</project>
	</xsl:template>
</xsl:stylesheet>

