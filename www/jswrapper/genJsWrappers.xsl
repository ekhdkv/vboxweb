<xsl:stylesheet version = '1.0'
     xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
     xmlns:vbox="http://www.virtualbox.org/">

<!--
        XSLT stylesheet that generates VirtualBox_main.js from
        VirtualBox.xidl.

        Copyright (C) 2009 Sun Microsystems, Inc.
-->

<xsl:output
  method="text"
  version="1.0"
  encoding="utf-8"
  indent="no"/>

<xsl:template name="jsClassName">
  <xsl:param name="name" />
  <xsl:value-of select="concat('vbox',$name,'Impl')"/>
</xsl:template>

<xsl:template name="capitalize">
  <xsl:param name="str" select="."/>
  <xsl:value-of select="
        concat(
            translate(substring($str,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
            substring($str,2)
        )
  "/>
</xsl:template>

<xsl:template name="makeGetterName">
  <xsl:param name="attr" />
  <xsl:variable name="capsname">
    <xsl:call-template name="capitalize">
      <xsl:with-param name="str" select="$attr" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat('get', $capsname)" />
</xsl:template>


<xsl:template name="genGetter">
  <xsl:variable name="getterName">
    <xsl:call-template name="makeGetterName">
      <xsl:with-param name="attr" select="@name" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat('    ',$getterName,': function()&#10;    {&#10;')"/>
  <xsl:value-of select="concat('        return this.jsonObject.',@name,';&#10;    },&#10;')" />
</xsl:template>

<xsl:template name="genSetter">
  <!-- is it really meaningful ? -->
</xsl:template>

<xsl:template name="method" >
   <xsl:value-of select="@name"/><xsl:text>: function(</xsl:text>
   <xsl:for-each select="param[@dir='in']">
     <xsl:value-of select="@name"/>
     <xsl:text>, </xsl:text>
   </xsl:for-each>
   <xsl:text>)&#10;    {&#10;</xsl:text>
   <xsl:value-of select="concat('        return  this.jsonObject.',@name,';&#10;    },&#10;')" />
</xsl:template>

<xsl:template name="computeExtends">
  <xsl:param name="extends" />
  <xsl:variable name="jsExtends">
    <xsl:call-template name="jsClassName">
      <xsl:with-param name="name" select="@extends" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="($extends = '$unknown') or ($extends = '$dispatched')">
      <xsl:value-of select="''"/>
    </xsl:when>
    <xsl:when test="($extends = '$errorinfo') or not ($extends)">
      <xsl:value-of select="''"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($jsExtends, ',')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="/">
 <xsl:text>/* Copyright (C) 2009 Sun Microsystems, Inc.

 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:

 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 * Javascript classes for use with PrototypeJS/JSON.
 * This file is autogenerated from VirtualBox.xidl, DO NOT EDIT!
 */
</xsl:text>

 <xsl:for-each select="//interface">
    <xsl:variable name="name" select="@name" />
    <xsl:variable name="base">
     <xsl:call-template name="computeExtends">
       <xsl:with-param name="extends" select="@extends" />
     </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="classname">
       <xsl:call-template name="jsClassName">
        <xsl:with-param name="name" select="$name" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="concat('var ', $classname, ' = Class.create(', $base, '&#10;{')" />
    <xsl:text>
    initialize: function(jsonObject)
    {
        this.jsonObject = jsonObject;
    },
    </xsl:text>
    <xsl:for-each select="attribute">
      <xsl:call-template name="genGetter" />
      <xsl:choose>
        <xsl:when test="@readonly='yes'">
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="genSetter" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text>
    <!-- @todo move the following function(s) into a base class later -->
    loadSettingsJSON: function(jsonObject)
    {
        this.jsonObject = jsonObject;
    }
    </xsl:text>
});

</xsl:for-each>

</xsl:template>

</xsl:stylesheet>
