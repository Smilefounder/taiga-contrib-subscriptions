###
# Copyright (C) 2014-2019 Taiga Agile LLC
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# File: lightbox-invalid-plan.controller.coffee
###

module = angular.module('subscriptions')

class LightboxInvalidPlanController
    @.$inject = [
        "lightboxService"
    ]

    constructor: (@lightboxService) ->
        @.annotationVisible = false

    toggleAnnotation:() ->
        @.annotationVisible = !@.annotationVisible

    close: () ->
        @.mode = null
        @.annotationVisible = false
        @lightboxService.closeAll()

    confirmCancel: () ->
        @lightboxService.open('tg-lb-confirm-cancel-plan')

module.controller("ContribLbInvalidPlanController", LightboxInvalidPlanController)
