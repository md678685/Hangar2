<#import "/spring.ftl" as spring />
<#import "*/utils/hangar.ftlh" as hangar />
<#import "*/layout/base.ftlh" as base />

@import controllers.sugar.Requests.OreRequest
@import models.viewhelper.{OrganizationData, UserData}
@import ore.OreConfig
@import ore.db.Model
@import ore.models.organization.Organization
@import ore.models.project.Project
@import ore.models.user.User
@import ore.models.user.role.{OrganizationUserRole, ProjectUserRole, UserRoleModel}
@import ore.permission.role.Role
@(user: UserData, orga: Option[OrganizationData], userProjectRoles: Seq[(Project, Model[ProjectUserRole])])(implicit messages: Messages, request: OreRequest[_], config: OreConfig, flash: Flash, assetsFinder: AssetsFinder)

@prefix = @{"Edit " + (if(user.isOrga) "Organization" else "User") + ": "}

@orgRoles = @{Role.organizationRoles.filter(r => r.isAssignable || r == Role.OrganizationOwner)}
@projectRoles = @{Role.projectRoles.filter(r => r.isAssignable || r == Role.ProjectOwner)}

<#macro panel title size=12>
    <div class="col-md-${size}">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h4 class="panel-title">${title}</h4>
            </div>
            <#nested />
        </div>
    </div>
</#macro>

@roleTable[T, M <: UserRoleModel[M]](keyName: String, tableType: String, withOwner: Boolean, roles: Set[(T, Model[M], String)], roleTypes: IndexedSeq[Role])(showKey: (T, M) => Html) = {
    <table class="table role-table">
        <tr><th>${keyName}</th><#if withOwner><th>Owner</th></#if><th>Role</th><th>Accepted</th></tr>
        @roles.map { case (t, role, owner) =>
        <tr data-role-type="@tableType" data-role-id="${role.id}">
            <td>@showKey(t, role)</td>
            <#if withOwner>
                <td><a href="${routes.getRouteUrl("userAdmin", owner)}">${owner}</a></td>
            </#if>
            <#if !role.role.isAssignable>
                <td colspan="3">
                ${role.role.title}
                </td>
            <#else>
                <td><select class="select-role">
                <#list roleTypes as roleType>
                    <option value="${roleType.value}" <#if role.role == roleType>selected</#if>
                    <#if roleType == Role.ProjectOwner || roleType == Role.OrganizationOwner>data-refresh="true"</#if>>${roleType.title}</option>
                </#list>
                </select></td>
                <td><input type="checkbox" class="role-accepted" <#if role.isAccepted>checked</#if></td>
                <td><a href="#" class="delete-role"><i class="fas fa-trash"></i></a></td>
            </#if>
        </tr>
        }
    </table>
}

<#assign scriptsVar>
    <script type="text/javascript" src="<@hangar.url "javascripts/userAdmin.js" />"></script>
</#assign>

<@base.base title=(prefix + user.user.name) additionalScripts=scriptsVar>

    <div class="row">
        <div class="col-md-12">
            <h1>${prefix}<a href="${routes.getRouteUrl("users.showProjects", user.user.name)}">${user.user.name}</a></h1>
        </div>
    </div>

    <div class="row">
        <div class="col-md-9">

            <div class="row">
            <#if !user.isOrga>
                <@panel "Organizations">
                    @roleTable[Model[Organization], OrganizationUserRole]("Organization", "orgRole", withOwner = true, user.orgas.map(t => (t._1, t._3, t._4.name)).toSet, orgRoles) { (org, _) =>
                        <a href="${routes.getRouteUrl("userAdmin", org.name)}">
                        ${org.name}
                        </a>
                    }
                </@panel>
            <#else>
                <@panel "Members">
                    @roleTable[Model[User], OrganizationUserRole]("User", "memberRole", withOwner = false, orga.members.map(t => (t._2, t._1, null)).toSet, orgRoles) { (user, _) =>
                        <a href="${routes.getRouteUrl("userAdmin", user.name)}">
                        ${user.name}
                        </a>
                    }
                </@panel>
            </#if>
            </div>
            <#if !user.isOrga>
                <div class="row">
                <@panel "Projects">
                    @roleTable[Project, ProjectUserRole]("Project", "projectRole", withOwner = true, userProjectRoles.map(t => (t._1, t._2, t._1.ownerName)).toSet, projectRoles) { (project, _) =>
                        <a href="${routes.getRouteUrl("projects.show", project.ownerName, project.slug)}">
                        ${project.name}
                        </a>
                    }
                </@panel>
                </div>
            </#if>
        </div>

        <@panel title="Other Administration" size=3>
            <div class="list-group">
                <div class="list-group-item">
                    <a href="${config.security.api.url}/admin/accounts/user/${user.user.id}/change/">HangarAuth Profile</a>
                </div>
                <div class="list-group-item">
                    <a href="https://papermc.io/forums${user.user.name}">Forum Profile</a>
                </div>
            </div>
        </@panel>

    </div>

</@base.base>
