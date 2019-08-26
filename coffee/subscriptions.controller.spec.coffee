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
# File: subscriptions.controller.spec.coffee
###

describe "SubscriptionsController", ->
    provide = null
    controller = null
    mocks = {}

    _mockTranslatePartialLoader = () ->
        mocks.translatePartialLoader = {
            addPart: sinon.stub()
        }

        provide.value "$translatePartialLoader", mocks.translatePartialLoader

    _mockTranslate = () ->
        mocks.translate = {
            instant: sinon.stub()
        }

        provide.value "$translate", mocks.translate

    _mockAppMetaService = () ->
        mocks.appMetaService = {
            setAll: sinon.stub()
        }

        provide.value "tgAppMetaService", mocks.appMetaService

    _mockContribSubscriptionsService = () ->
        mocks.contribSubscriptionsService = {
            fetchMyPlans: sinon.stub(),
            fetchPublicPlans: sinon.stub(),
            selectMyPlan: sinon.stub(),
            getMyPerSeatPlan: sinon.stub(),
            loadUserPlan: sinon.stub(),
            createSubscription: sinon.stub()
        }

        provide.value "ContribSubscriptionsService", mocks.contribSubscriptionsService

    _mockTgLoader = () ->
        mocks.tgLoader = {
            start: sinon.stub(),
            pageLoaded: sinon.stub()
        }

        provide.value "tgLoader", mocks.tgLoader

    _mockLightboxService = () ->
        mocks.lightboxService = {
            open: sinon.stub()
        }
        provide.value "lightboxService", mocks.lightboxService

    _paymentsService = () ->
        mocks.paymentsService = {
            changeData: sinon.stub()
            seeBilling: sinon.stub()
        }
        provide.value "ContribPaymentsService", mocks.paymentsService

    _mockTgConfirm = () ->
        mocks.tgConfirm = {
            notify: sinon.stub()
        }
        provide.value "$tgConfirm", mocks.tgConfirm

    _mockTgCurrentUserService = () ->
        mocks.tgCurrentUserService = {
            getUser: sinon.stub(),
            projectsById: sinon.stub()
        }
        provide.value "tgCurrentUserService", mocks.tgCurrentUserService

    _mockTgUserService = () ->
        mocks.tgUserService = {
            getContacts: sinon.stub(),
        }
        provide.value "tgUserService", mocks.tgUserService

    _mockTgAuth = () ->
        mocks.tgAuth = {
            refresh: sinon.stub(),
        }
        provide.value "$tgAuth", mocks.tgAuth

    _mockTgConfig = () ->
        mocks.tgConfig = {
            get: sinon.stub()
        }
        provide.value "$tgConfig", mocks.tgConfig

    _mockTgTranslate = () ->
        mocks.tgTranslate = {
            instant: sinon.stub()
        }
        provide.value "$translate", mocks.tgTranslate

    _mockTgAnalytics = ->
        mocks.tgAnalytics = {
            trackEvent: sinon.stub()
            ecAddToCart: sinon.stub()
            ecConfirmChange: sinon.stub()
            ecListPlans: sinon.stub()
        }

        provide.value("$tgAnalytics", mocks.tgAnalytics)

    _mockRouteParams = ->
        mocks.routeParams = {
            payment_result: sinon.stub()
        }
        provide.value "$routeParams", mocks.routeParams

    _mocks = () ->
        module ($provide) ->
            provide = $provide
            _mockAppMetaService()
            _mockContribSubscriptionsService()
            _mockTgLoader()
            _mockLightboxService()
            _mockTranslatePartialLoader()
            _mockTranslate()
            _paymentsService()
            _mockTgConfirm()
            _mockTgTranslate()
            _mockTgAnalytics()
            _mockTgConfig()
            _mockTgCurrentUserService()
            _mockTgUserService()
            _mockTgAuth()
            _mockRouteParams()

            return null

    beforeEach ->
        module "subscriptions"

        _mocks()

        inject ($controller) ->
            controller = $controller

    it "load metas", () ->
        subscriptionsCtrl = controller "ContribSubscriptionsController"

        title = 'title'
        description = 'description'

        mocks.tgTranslate.instant.withArgs('SUBSCRIPTIONS.TITLE').returns(title)
        mocks.tgTranslate.instant.withArgs('SUBSCRIPTIONS.SECTION_NAME').returns(description)

        subscriptionsCtrl._loadMetas()
        expect(mocks.appMetaService.setAll).have.been.calledWith(title, description)

    it "load User Plans", (done) ->
        promise1 = mocks.contribSubscriptionsService.getMyPerSeatPlan.promise()
        promise2 = mocks.contribSubscriptionsService.loadUserPlan.promise()
        promise3 = mocks.contribSubscriptionsService.fetchPublicPlans.promise()
        subscriptionsCtrl = controller "ContribSubscriptionsController"
        subscriptionsCtrl.publicPlans = []
        subscriptionsCtrl.notify = {}
        subscriptionsCtrl.perSeatPlan = {}

        subscriptionsCtrl._loadPlans().then () ->
            expect(mocks.tgLoader.pageLoaded).have.been.called
            done()

        expect(mocks.tgLoader.start).have.been.called

        promise1.resolve()
        promise2.resolve()
        promise3.resolve()

    it "change Payments Data", () ->
        subscriptionsCtrl = controller "ContribSubscriptionsController"

        subscriptionsCtrl._onSuccessChangePaymentsData = sinon.stub()

        subscriptionsCtrl.changePaymentsData()
        expect(mocks.paymentsService.changeData).has.been.called
        mocks.paymentsService.changeData.yieldTo('onSuccess')
        expect(subscriptionsCtrl._onSuccessChangePaymentsData).to.be.called

    it "changed Payments Data", (done) ->
        subscriptionsCtrl = controller "ContribSubscriptionsController"
        data = {test: true}

        mocks.contribSubscriptionsService.selectMyPlan.withArgs(data).promise().resolve()

        subscriptionsCtrl._onSuccessChangedData = sinon.stub()

        subscriptionsCtrl._onSuccessChangePaymentsData(data).then () ->
            expect(mocks.tgLoader.start).has.been.called
            expect(subscriptionsCtrl._onSuccessChangedData).to.be.called
            done()

    it "see Billing details", () ->
        subscriptionsCtrl = controller "ContribSubscriptionsController"

        subscriptionsCtrl.myPlan = {
            secure_id: 'secure_id'
        }

        subscriptionsCtrl.seeBillingDetails()
        expect(mocks.paymentsService.seeBilling).has.been.calledWith(subscriptionsCtrl.myPlan)

    it "create payment session", () ->
        user = Immutable.fromJS({
            email: "user@taigaio.test"
            full_name: "User 1"
        })

        subscriptionsCtrl = controller "ContribSubscriptionsController"
        subscriptionsCtrl.user = user
        subscriptionsCtrl.publicPlans = []
        subscriptionsCtrl.notify = {}
        subscriptionsCtrl.perSeatPlan = { members: [] }
        subscriptionsCtrl.myPlan = {
            customer_id: null,
            email: "test@test.test",
            interval: "month",
            current_plan: {
                id: "per-seat-free",
                id_month: null,
                id_year: null,
                name: "Basic",
                amount_month: 0,
                amount_year: null,
                currency: "usd",
            }
        }

        data = {
            amount_month: 7,
            amount_year: 60,
            currency: "usd",
            id: null,
            id_month: "per-seat-month",
            id_year: "per-seat-year",
            is_applicable: true,
            name: "Premium",
            private_projects: null,
            project_members: null
        }

        promise = mocks.contribSubscriptionsService.createSubscription.promise().resolve()

        subscriptionsCtrl.changePlan(data)

        expect(mocks.contribSubscriptionsService.createSubscription).has.been.called

    it "create payment session error", () ->
        user = Immutable.fromJS({
            email: "user@taigaio.test"
            full_name: "User 1"
        })

        subscriptionsCtrl = controller "ContribSubscriptionsController"
        subscriptionsCtrl.user = user
        subscriptionsCtrl.publicPlans = []
        subscriptionsCtrl.notify = {}
        subscriptionsCtrl.perSeatPlan = { members: [] }
        subscriptionsCtrl.myPlan = {
            customer_id: null,
            email: "test@test.test",
            interval: "month",
            current_plan: {
                id: "per-seat-free",
                id_month: null,
                id_year: null,
                name: "Basic",
                amount_month: 0,
                amount_year: null,
                currency: "usd",
            }
        }

        data = {
            amount_month: 7,
            amount_year: 60,
            currency: "usd",
            id: null,
            id_month: "per-seat-month",
            id_year: "per-seat-year",
            is_applicable: true,
            name: "Premium",
            private_projects: null,
            project_members: null
        }

        mocks.contribSubscriptionsService.createSubscription.promise().reject(new Error('error'))

        subscriptionsCtrl.changePlan({}).then () ->
            expect(mocks.tgConfirm.notify).has.been.calledWith("error")

    it "payment success", () ->
        mocks.routeParams.payment_result = "success"

        subscriptionsCtrl = controller "ContribSubscriptionsController"
        subscriptionsCtrl.checkPaymentResult()
        expect(subscriptionsCtrl.paymentSuccess).to.be.eql(true)
        expect(subscriptionsCtrl.paymentError).to.be.eql(false)


    it "payment error", () ->
        mocks.routeParams.payment_result = "error"

        subscriptionsCtrl = controller "ContribSubscriptionsController"
        subscriptionsCtrl.checkPaymentResult()

        expect(subscriptionsCtrl.paymentSuccess).to.be.eql(false)
        expect(subscriptionsCtrl.paymentError).to.be.eql(true)
