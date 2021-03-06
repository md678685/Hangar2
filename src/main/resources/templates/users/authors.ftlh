<#import "/spring.ftl" as spring />
<#import "*/utils/hangar.ftlh" as hangar />
<#import "*/layout/base.ftlh" as base />

<#--
@import java.time.OffsetDateTime

@import controllers.sugar.Requests.OreRequest
@import db.impl.access.UserBase.UserOrdering
@import ore.OreConfig
@import ore.models.user.User
@import ore.permission.role.Role
@import util.StringFormatterUtils._
@import util.syntax._
@import views.html.helper.CSPNonce
@import views.html.utils.userAvatar
@(authors: Seq[(String, Option[OffsetDateTime], OffsetDateTime, Option[Role], Option[Role], Long)], ordering: String, page: Int)(implicit messages: Messages, request: OreRequest[_], config: OreConfig, flash: Flash, assetsFinder: AssetsFinder)

@pageSize = @{ config.ore.users.authorPageSize }
-->
<#assign pageSize=config.user.authorPageSize />

<#function direction>
	<#if ordering?startsWith("-")>
		<#return "chevron-down">
	<#else>
		<#return "chevron-up">
	</#if>
</#function>

<#function isActiveSort td>
	<#assign sort=ordering>
	<#if sort?startsWith("-")>
		<#assign sort=sort?substring(1)>
	</#if>
	<#return sort?upperCase == td?upperCase>
</#function>

<#assign scriptsVar>
	<script type="text/javascript" src="<@hangar.url "javascripts/userList.js" />"></script>
	<script <#--@CSPNonce.attr-->>CURRENT_PAGE = ${page};</script>
</#assign>

<#-- @ftlvariable name="page" type="java.lang.Integer" -->
<@base.base title="Authors - Hangar" additionalScripts=scriptsVar>
    <#assign UserOrdering = @helper["me.minidigger.hangar.model.UserOrdering"]>
<#-- @ftlvariable name="UserOrdering" type="me.minidigger.hangar.model.UserOrdering" -->
    <div class="panel panel-default">
        <table class="table table-users">
            <thead>
                <tr>
                    <td></td>
                    <td <#if isActiveSort(UserOrdering.UserName)>class="user-sort"</#if> data-list="authors" >
                        Username
                        <#if isActiveSort(UserOrdering.UserName)><i class="o fas fa-${direction()}"></i></#if>
                    </td>
                    <td <#if isActiveSort(UserOrdering.Role)>class="user-sort"</#if> data-list="authors" >
                        Roles
                        <#if isActiveSort(UserOrdering.Role)><i class="o fas fa-${direction()}"></i></#if>
                    </td>
                    <td <#if isActiveSort(UserOrdering.JoinDate)>class="user-sort"</#if> data-list="authors" >
                        Joined
                        <#if isActiveSort(UserOrdering.JoinDate)><i class="o fas fa-${direction()}"></i></#if>
                    </td>
                    <td <#if isActiveSort(UserOrdering.Projects)>class="user-sort"</#if> data-list="authors" >
                        Projects
                        <#if isActiveSort(UserOrdering.Projects)><i class="o fas fa-${direction()}"></i></#if>
                    </td>
                </tr>
            </thead>
            <tbody>
                <#list authors as author>
                <tr>
                    <#import "*/utils/userAvatar.ftlh" as userAvatar>
                    <td><@userAvatar.userAvatar userName=author.name avatarUrl=author.avatarUrl clazz="user-avatar-xs"></@userAvatar.userAvatar></td>
                    <td>
                        <a href="${routes.getRouteUrl("users.showProjects", author.name)}">${author.name}</a>
                    </td>
                    <td>
                        <#if author.donatorRole??>
                            <span class="channel channel-sm" style="background-color: ${author.donatorRole.color.hex}">
                            ${author.donatorRole}
                            </span>
                        </#if>
                        <#if author.role??>
                            <span class="user-role channel" style="background-color: ${author.role.color.hex}">
                            ${author.role.title}
                            </span>
                        </#if>
                    </td>
                    <td>${(author.joinDate!author.createdAt).format("yyyy-MM-dd")}</td>
                    <td>${author.count}</td>
                </tr>
                </#list>

                <#if page gt 1 || authors?size gte pageSize>
                    <tr class="authors-footer">
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>
                            <#if authors?size gte pageSize>
                                <a href="${routes.getRouteUrl("users.showAuthors", ordering, page + 1)}" class="btn btn-default">
                                    <i class="fas fa-arrow-right"></i>
                                </a>
                            </#if>

                            <#if page gt 1>
                                <a href="${routes.getRouteUrl("users.showAuthors", ordering, page - 1)}" class="btn btn-default">
                                    <i class="fas fa-arrow-left"></i>
                                </a>
                            </#if>
                        </td>
                    </tr>
                </#if>

            </tbody>
        </table>
    </div>
</@base.base>
