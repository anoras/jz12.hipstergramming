$ ->
    class AppRouter extends Support.SwappingRouter
        routes:
            '':                     'index'
            'contacts/new':         'new'
            'contacts/:id':         'show'
            'contacts/:id/edit':    'edit'

        initialize: (options) ->
            @el = options.el
            @collection = options.collection

        index: ->
            view = new LayoutView(
                listView: new ContactListView(collection: @collection)
                )
            @swap(view)

        show: (id) ->
            contact = @collection.get(id)
            contact.fetch(
                success: (model, response) =>
                    view = new LayoutView(
                        listView: new ContactListView(collection: @collection),
                        detailView: new ShowContactView(model: contact)
                    )
                    @swap(view)
                error: (model, response) =>
                    alert("Unable to fetch model from server")
            )

        new: ->
            view = new LayoutView(
                    listView: new ContactListView(collection: @collection),
                    detailView: new EditOrCreateContactView(collection: @collection)
            )
            @swap(view)

        edit: (id) ->
            contact = @collection.get(id)
            contact.fetch(
                success: (model, response) =>
                    view = new LayoutView(
                        listView: new ContactListView(collection: @collection),
                        detailView: new EditOrCreateContactView(model: contact, collection: @collection)
                    )
                    @swap(view)
                error: (model, response) =>
                    alert("Unable to fetch model from server")
            )



    # -----------------------------------------------------
    class Contact extends Backbone.Model
        urlRoot: '/contacts'
        schema:
            firstName:  'Text'
            lastName:   'Text'
            email:      'Text'

    # -----------------------------------------------------
    class ContactCollection extends Backbone.Collection
        model: Contact
        url: '/contacts'

    # -----------------------------------------------------
    class LayoutView extends Support.CompositeView
        initialize: (options) ->
            @listView = options.listView
            @detailView = options.detailView

        render: ->
            @$el.html(Handlebars.templates.index())
            if (@listView?)
                @renderChild(@listView)
                @$('#list-view').html(@listView.el)
            if (@detailView?)
                @renderChild(@detailView)
                @$('#detail-view').html(@detailView.el)
            @


    # -----------------------------------------------------
    class ContactListView extends Support.CompositeView
        initialize: ->
            @collection.on('add destroy', @render)
        render: =>
            @$el.html Handlebars.templates.contact_list(contacts: @collection.toJSON())
            @

    # -----------------------------------------------------
    class EditOrCreateContactView extends Support.CompositeView
        events:
            'submit':                       'save'
            'click #delete-contact-btn':    'delete'

        initialize: ->
            @model ?= new Contact()

        render: ->
            @form = new Backbone.Form(model: @model)
            @$el.append(@form.render().el)
            @form.$el.append(Handlebars.templates.contact_form_buttons(@model.toJSON()))
            @

        save: (e) ->
            e.preventDefault()
            @form.commit()
            @form.model.save({},
                success: (model, response) =>
                    @collection.add(model)

                error: (model, response) =>
                    alert(response)

            )
            false
            
        delete: ->
            @model.destroy()

    # -----------------------------------------------------
    class ShowContactView extends Support.CompositeView
        render: ->
            @$el.html Handlebars.templates.contact_details(@model.toJSON())
            @

    # -----------------------------------------------------
    contacts = new ContactCollection(JSON.parse($('#contacts-data').html()))
    router = new AppRouter(collection: contacts, el: $('div#app'))
    Backbone.history.start() unless Backbone.history.started

    appId = UUIDjs.create().toString();
    eventbus = new vertx.EventBus('http://0.0.0.0:8080/eventbus')
    eventbus.onopen = =>
        contacts.on('add', (model) ->
            eventbus.publish('contact:add', senderId: appId, model: model)
        )

        eventbus.registerHandler('contact:add', (msg, replyTo) ->
             alert("#{JSON.stringify(msg)} #{replyTo}") unless msg.senderId == appId
        )
    eventbus.onclose = ->
        console.log "Disconnected from event bus"