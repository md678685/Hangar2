<#import "/spring.ftl" as spring />
<#import "*/utils/hangar.ftlh" as hangar />
<#import "*/layout/base.ftlh" as base />

<#--
@import java.time.OffsetDateTime

@import controllers.sugar.Requests.OreRequest
@import models.querymodels.{FlagActivity, ReviewActivity}
@import ore.OreConfig
@import util.StringFormatterUtils._
@(username: String, activities: Seq[Either[FlagActivity, ReviewActivity]])(implicit messages: Messages, request: OreRequest[_], config: OreConfig, flash: Flash, assetsFinder: AssetsFinder)
-->

<#assign message><@spring.message "activity.title" /></#assign>
<@base.base title=("${message} ${username}")>

    <div class="row">
        <div class="col-md-12  header-flags">
            <div class="clearfix">
                <h1 class="pull-left"><@spring.message "activity.title" /> <i>${username}</i></h1>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title pull-left"><@spring.message "activity.title" /></h4>
                    <div class="clearfix"></div>
                </div>
                <table class="table table-condensed setting-no-border table-review-log">
                    <tbody>
                        <#if activities.isEmpty>
                            <tr><td>No activities founds</td></tr>
                        </#if>
                        @activities.map {
                            case Right(review) => {
                                <tr>
                                    <td>Review approved</td>
                                    <td>${(review.endedAt!OffsetDateTime.MIN)?string.long}</td>
                                    <td>for:
                                        <a href="${routes.getRouteUrl("reviews.showReviews", review.project.ownerName, review.project.slug, review.id.toString)}">
                                            ${review.project.ownerName} / ${review.project.slug}
                                        </a>
                                    </td>
                                </tr>
                            }
                            case Left(flag) => {
                                <tr>
                                    <td>Flag resolved</td>
                                    <td>${(flag.resolvedAt!OffsetDateTime.MIN)?string.long}</td>
                                    <td>for:
                                        <a href="${routes.getRouteUrl("projects.show", flag.project.ownerName, flag.project.slug)}">
                                            ${flag.project.ownerName} / ${flag.project.slug}
                                        </a>
                                    </td>
                                </tr>
                            }
                        }
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</@base.base>
