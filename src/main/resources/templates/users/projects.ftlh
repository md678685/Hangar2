<#import "/spring.ftl" as spring />
<#import "*/utils/hangar.ftlh" as hangar />
<#import "*/users/view.ftlh" as users />
<#import "*/users/memberList.ftlh" as memberList />

<#--@import controllers.routes.{Users => userRoutes}
@import controllers.sugar.Requests.OreRequest
@import models.viewhelper.{OrganizationData, ScopedOrganizationData, UserData}
@import ore.OreConfig
@import ore.permission.Permission
@import ore.permission.role.Role
@import util.syntax._
@import views.html.utils.userAvatar
@(u: UserData, o: Option[(OrganizationData, ScopedOrganizationData)])(
        implicit messages: Messages, flash: Flash, request: OreRequest[_], config: OreConfig, assetsFinder: AssetsFinder)-->

<#function canEditOrgMembers>
    <#return u.isOrga() && o?? && o.scopedData.permissions.has(Permissions.ManageOrganizationMembers)>
</#function>

<#assign scriptsVar>
    <script type="text/javascript" src="<@hangar.url "build/user-profile.js" />"></script>
    <#if u.isOrga() && o?? && canEditOrgMembers()>
    <script type="text/javascript" src="<@hangar.url "javascripts/orgInvites.js" />"></script>
    </#if>
    <script type="text/javascript" src="<@hangar.url "javascripts/userSearch.js" />"></script>
    <script type="text/javascript" src="<@hangar.url "javascripts/memberList.js" />"></script>
</#assign>

<@users.view u=u o=o additionalScripts=scriptsVar>
    <div class="row">
        <div class="col-md-8">
            <div id="user-profile"></div>
        </div>
        <div class="col-md-4">
            <#if u.isOrga() && o?? && canEditOrgMembers()>
                <div class="panel-user-info panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title"><@spring.message "project.manager" /></h3>
                    </div>
                    <table class="table panel-body">
                        <tbody>
                            @o._1.projectRoles.map { case (role, project) =>
                            <tr>
                                <td>
                                    <a href="${routes.getRouteUrl("projects.show", project.ownerName, project.slug)}">${project.ownerName}/${project.slug}</a>
                                    <span class="minor">${role.role.title}</span>
                                </td>
                                <td>
                                    <#if role.role != Role.ProjectOwner>
                                        <#if role.isAccepted>
                                            <button class="btn btn-sm btn-danger pull-right btn-invite" data-invite-id="${role.id}" data-invite-behalf="${u.user.name}" data-invite-accepted="decline">Leave</button>
                                        <#else>
                                            <button class="btn btn-sm btn-info pull-right btn-invite" data-invite-id="${role.id}" data-invite-behalf="${u.user.name}" data-invite-accepted="accept">Join</button>
                                        </#if>
                                    </#if>
                                </td>
                            </tr>
                            }
                        </tbody>
                    </table>
                </div>
            </#if>
            <#if !u.isOrga()>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title"> <@spring.message "org.plural" /></h3>
                    </div>
                    <table class="table panel-body">
                        <tbody>
                        <#if u.orgas?size == 0>
                            <tr><td><i class="minor"><i class="fas fa-star"></i> <@spring.messageArgs code="user.noOrganizations" args=[u.user.name] /></i></td></tr>
                        <#else>
                            <#list u.orgas as organization> <#-- , user, role -->
                            <tr>
                                <td>
                                    <#import "*/utils/userAvatar.ftlh" as userAvatar>
                                    <@userAvatar.userAvatar userName=organization.name avatarUrl=user.avatarUrl clazz="user-avatar-xxs"></@userAvatar.userAvatar>
                                <a href="${routes.getRouteUrl("users.showProjects", organization.name)}">
                                ${organization.name}
                                </a>
                                <div class="pull-right">
                                ${role.role.title}
                            </div>
                            </td>
                            </tr>
                            </#list>
                        </#if>
                        </tbody>
                    </table>

                    <div class="panel-footer">
                        <div class="clearfix"></div>
                    </div>
                </div>

                <div class="panel-user-info panel panel-default" data-action="starred">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fas fa-star"></i> <@spring.message "project.starred" /></h3>
                    </div>
                    <table class="table panel-body">
                        <tbody>
                        </tbody>
                    </table>

                    <div class="panel-footer">
                        <div class="pull-right">
                            <a class="prev" href="#" style="display: none;">&laquo;</a>
                            <a class="next" href="#" >&raquo;</a>
                        </div>
                        <div class="clearfix"></div>
                    </div>
                </div>

                <div class="panel-user-info panel panel-default" data-action="watching">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fas fa-eye"></i> <@spring.message "project.watching" /></h3>
                    </div>
                    <table class="table panel-body">
                        <tbody>
                        </tbody>
                    </table>

                    <div class="panel-footer">
                        <div class="pull-right">
                            <a class="prev" href="#" style="display: none;">&laquo;</a>
                            <a class="next" href="#" >&raquo;</a>
                        </div>
                        <div class="clearfix"></div>
                    </div>
                </div>
            <#else>
                <#assign orgData=o> <#-- todo fix scopeddata -->
                <@memberList.memberList j=orgData editable=true perms=scopedData.permissions
                saveCall=routes.getRouteUrl("org.updateMembers", orgData.orga.name)
                removeCall=routes.getRouteUrl("org.removeMember", orgData.orga.name) />
            </#if>
        </div>
    </div>
</@users.view>
