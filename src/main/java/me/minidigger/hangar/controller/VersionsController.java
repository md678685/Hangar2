package me.minidigger.hangar.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

import me.minidigger.hangar.model.viewhelpers.ProjectData;
import me.minidigger.hangar.model.viewhelpers.ScopedProjectData;
import me.minidigger.hangar.model.viewhelpers.VersionData;
import me.minidigger.hangar.service.VersionService;
import me.minidigger.hangar.service.project.ProjectService;

@Controller
public class VersionsController extends HangarController {

    private final ProjectService projectService;
    private final VersionService versionService;

    @Autowired
    public VersionsController(ProjectService projectService, VersionService versionService) {
        this.projectService = projectService;
        this.versionService = versionService;
    }

    @RequestMapping("/api/project/{pluginId}/versions/recommended/download")
    public Object downloadRecommendedJarById(@PathVariable Object pluginId, @RequestParam Object token) {
        return null; // TODO implement downloadRecommendedJarById request controller
    }

    @RequestMapping("/api/project/{pluginId}/versions/{name}/download")
    public Object downloadJarById(@PathVariable Object pluginId, @PathVariable Object name, @RequestParam Object token) {
        return null; // TODO implement downloadJarById request controller
    }

    @RequestMapping("/{author}/{slug}/versionLog")
    public Object showLog(@PathVariable Object author, @PathVariable Object slug, @RequestParam Object versionString) {
        return null; // TODO implement showLog request controller
    }

    @RequestMapping("/{author}/{slug}/versions")
    public ModelAndView showList(@PathVariable String author, @PathVariable String slug) {
        ModelAndView mav = new ModelAndView("projects/versions/list");
        ProjectData projectData = projectService.getProjectData(author, slug);
        ScopedProjectData sp = projectService.getScopedProjectData(projectData.getProject().getId());
        mav.addObject("sp", sp);
        mav.addObject("p", projectData);
        mav.addObject("channels", List.of()); // TODO channel list
        return fillModel(mav);
    }

    @Secured("ROLE_USER")
    @RequestMapping("/{author}/{slug}/versions/new")
    public Object showCreator(@PathVariable Object author, @PathVariable Object slug) {
        return null; // TODO implement showCreator request controller
    }

    @Secured("ROLE_USER")
    @RequestMapping("/{author}/{slug}/versions/new/upload")
    public Object upload(@PathVariable Object author, @PathVariable Object slug) {
        return null; // TODO implement upload request controller
    }

    @Secured("ROLE_USER")
    @RequestMapping("/{author}/{slug}/versions/new/{version}")
    public Object showCreatorWithMeta(@PathVariable Object author, @PathVariable Object slug, @PathVariable Object version) {
        return null; // TODO implement showCreatorWithMeta request controller
    }

    @RequestMapping("/{author}/{slug}/versions/recommended/download")
    public Object downloadRecommended(@PathVariable Object author, @PathVariable Object slug, @RequestParam Object token) {
        return null; // TODO implement downloadRecommended request controller
    }

    @RequestMapping("/{author}/{slug}/versions/recommended/jar")
    public Object downloadRecommendedJar(@PathVariable Object author, @PathVariable Object slug, @RequestParam Object token) {
        return null; // TODO implement downloadRecommendedJar request controller
    }

    @Secured("ROLE_USER")
    @RequestMapping("/{author}/{slug}/versions/{version}")
    public Object publish(@PathVariable Object author, @PathVariable Object slug, @PathVariable Object version) {
        return null; // TODO implement publish request controller
    }

    @GetMapping("/{author}/{slug}/versions/{version}")
    public ModelAndView show(@PathVariable String author, @PathVariable String slug, @PathVariable String version) {
        ModelAndView mav = new ModelAndView("projects/versions/view");
        ProjectData projectData = projectService.getProjectData(author, slug);
        ScopedProjectData sp = projectService.getScopedProjectData(projectData.getProject().getId());
        mav.addObject("v", new VersionData(projectData, versionService.getVersion(projectData.getProject().getId()), null));
        mav.addObject("sp", sp);
        return fillModel(mav);  // TODO implement show request controller
    }

    @Secured("ROLE_USER")
    @RequestMapping("/{author}/{slug}/versions/{version}/approve")
    public Object approve(@PathVariable Object author, @PathVariable Object slug, @PathVariable Object version) {
        return null; // TODO implement approve request controller
    }

    @Secured("ROLE_USER")
    @RequestMapping("/{author}/{slug}/versions/{version}/approvePartial")
    public Object approvePartial(@PathVariable Object author, @PathVariable Object slug, @PathVariable Object version) {
        return null; // TODO implement approvePartial request controller
    }

    @RequestMapping("/{author}/{slug}/versions/{version}/confirm")
    public Object showDownloadConfirm(@PathVariable Object author, @PathVariable Object slug, @PathVariable Object version, @RequestParam Object downloadType, @RequestParam Object api, @RequestParam Object dummy) {
        return null; // TODO implement showDownloadConfirm request controller
    }

    @PostMapping("/{author}/{slug}/versions/{version}/confirm")
    public Object confirmDownload(@PathVariable Object author, @PathVariable Object slug, @PathVariable Object version, @RequestParam Object downloadType, @RequestParam Object api, @RequestParam Object dummy) {
        return null; // TODO implement confirmDownload request controller
    }

    @Secured("ROLE_USER")
    @RequestMapping("/{author}/{slug}/versions/{version}/delete")
    public Object softDelete(@PathVariable Object author, @PathVariable Object slug, @PathVariable Object version) {
        return null; // TODO implement softDelete request controller
    }

    @RequestMapping("/{author}/{slug}/versions/{version}/download")
    public Object download(@PathVariable Object author, @PathVariable Object slug, @PathVariable Object version, @RequestParam Object token, @RequestParam Object confirm) {
        return null; // TODO implement download request controller
    }

    @Secured("ROLE_USER")
    @RequestMapping("/{author}/{slug}/versions/{version}/hardDelete")
    public Object delete(@PathVariable Object author, @PathVariable Object slug, @PathVariable Object version) {
        return null; // TODO implement delete request controller
    }

    @RequestMapping("/{author}/{slug}/versions/{version}/jar")
    public Object downloadJar(@PathVariable Object author, @PathVariable Object slug, @PathVariable Object version, @RequestParam Object token) {
        return null; // TODO implement downloadJar request controller
    }

    @Secured("ROLE_USER")
    @RequestMapping("/{author}/{slug}/versions/{version}/recommended")
    public Object setRecommended(@PathVariable Object author, @PathVariable Object slug, @PathVariable Object version) {
        return null; // TODO implement setRecommended request controller
    }

    @Secured("ROLE_USER")
    @RequestMapping("/{author}/{slug}/versions/{version}/restore")
    public Object restore(@PathVariable Object author, @PathVariable Object slug, @PathVariable Object version) {
        return null; // TODO implement restore request controller
    }

    @Secured("ROLE_USER")
    @RequestMapping("/{author}/{slug}/versions/{version}/save")
    public Object saveDescription(@PathVariable Object author, @PathVariable Object slug, @PathVariable Object version) {
        return null; // TODO implement saveDescription request controller
    }

}

