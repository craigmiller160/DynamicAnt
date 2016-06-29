<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ant="https://github.com/craigmiller160/DynamicAnt" xmlns:regex="http://exslt.org/regular-expressions" exclude-result-prefixes="ant regex" version="2.0">
  <xsl:param name="home" />
  <xsl:template match="ant:ant">
    <xsl:variable name="userHome">
      <xsl:value-of select="replace($home,'/$','')" />
    </xsl:variable>
    <xsl:variable name="projectName" select="ant:project/@name" />
    <xsl:variable name="projectVersion" select="ant:project/@version" />
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
            <xsl:when test="ant:info/ant:author">
              <xsl:value-of select="ant:info/ant:author/@name" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>PilotFish Developer</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </property>
      <property name="dir.devRoot">
        <xsl:attribute name="value">
          <xsl:choose>
            <xsl:when test="ant:info/ant:devRoot">
              <xsl:variable name="devRootRaw" select="ant:info/ant:devRoot/@pathFromHome" />
              <xsl:value-of select="replace(replace($devRootRaw,'/$',''),'^/','')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$userHome" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </property>
      <property name="dir.devDir">
        <xsl:attribute name="value">
          <xsl:choose>
            <xsl:when test="ant:info/ant:devDir">
              <xsl:variable name="devDirRaw" select="ant:info/ant:devDir/@pathFromDevRoot" />
              <xsl:value-of select="replace(replace($devDirRaw,'/$',''),'^/','')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Main</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </property>
      <property name="dir.devDir.src">
        <xsl:attribute name="value">
          <xsl:text>${dir.devDir}/src</xsl:text>
        </xsl:attribute>
      </property>
      <property name="dir.devDir.subprojects">
        <xsl:attribute name="value">
          <xsl:text>${dir.devDir}/subprojects</xsl:text>
        </xsl:attribute>
      </property>
      <property name="dir.devDir.out">
        <xsl:attribute name="value">
          <xsl:text>${dir.devDir}/out/production</xsl:text>
        </xsl:attribute>
      </property>
      <property name="intellij.mainModule">
        <xsl:attribute name="value">
          <xsl:choose>
            <xsl:when test="ant:info/ant:mainModule">
              <xsl:value-of select="ant:info/ant:mainModule/@name" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>PilotFish</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
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
      <property name="dir.project.build.sources.src">
        <xsl:attribute name="value">
          <xsl:text>${dir.project.build.sources}/src</xsl:text>
        </xsl:attribute>
      </property>
      <property name="dir.project.build.sources.subprojects">
        <xsl:attribute name="value">
          <xsl:text>${dir.project.build.sources}/subprojects</xsl:text>
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
        <xsl:for-each select="ant:files/ant:file">
          <xsl:variable name="pkgVal" select="replace(replace(replace(@pkg,'^/',''),'/$',''),'\.','/')" />
          <mkdir>
            <xsl:attribute name="dir">
              <xsl:value-of select="concat('${dir.project.build}/',$pkgVal)" />
            </xsl:attribute>
          </mkdir>
          <xsl:variable name="sourceDirs">
            <xsl:choose>
              <xsl:when test="@subproject">
                <xsl:value-of select="concat('${dir.project.build.sources.subprojects}','/',@subproject,'/',$pkgVal)" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('${dir.project.build.sources.src}','/',$pkgVal)" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <mkdir>
            <xsl:attribute name="dir">
              <xsl:value-of select="$sourceDirs" />
            </xsl:attribute>
          </mkdir>
        </xsl:for-each>
      </target>
      <target depends="prepare" name="copy">
        <xsl:for-each select="ant:files/ant:file">
          <xsl:variable name="pkgVal" select="replace(replace(replace(@pkg,'^/',''),'/$',''),'\.','/')" />
          <copy>
            <xsl:attribute name="todir">
              <xsl:choose>
                <xsl:when test="@subproject">
                  <xsl:value-of select="concat('${dir.project.build.sources.subprojects}','/',@subproject,'/',$pkgVal)" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat('${dir.project.build.sources.src}','/',$pkgVal)" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="file">
              <xsl:choose>
                <xsl:when test="@subproject">
                  <xsl:value-of select="concat('${dir.devDir.subprojects}','/',@subproject,'/',$pkgVal,'/',@name,'.java')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat('${dir.devDir.src}','/',$pkgVal,'/',@name,'.java')" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </copy>
          <copy>
            <xsl:attribute name="todir">
              <xsl:value-of select="concat('${dir.project.build}','/',$pkgVal)" />
            </xsl:attribute>
            <fileset>
              <xsl:attribute name="dir">
                <xsl:choose>
                  <xsl:when test="@subproject">
                    <xsl:value-of select="concat('${dir.devDir.out}','/',@subproject,'/',$pkgVal)" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat('$dir.devDir.out}','/','${intellij.mainModule}','/',$pkgVal)" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="includes">
                <xsl:value-of select="concat(@name,'*.class')" />
              </xsl:attribute>
            </fileset>
          </copy>
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

