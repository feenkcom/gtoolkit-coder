Class {
	#name : #GtFilterTextViewModel,
	#superclass : #GtFilterViewModel,
	#category : #'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #accessing }
GtFilterTextViewModel >> filterElementClass [
	^ GtFilterTextSettingsElement
]

{ #category : #testing }
GtFilterTextViewModel >> inputFilter [
	<return: #BrTextEditorInputFilter>
	^ self filterModel inputFilter
]

{ #category : #'event handling' }
GtFilterTextViewModel >> onInputFilterChanged: anAnnouncement [
	self
		announce: (GtFilterTextViewModelInputFilterChanged new
				viewModel: self;
				inputFilter: anAnnouncement inputFilter)
]

{ #category : #'event handling' }
GtFilterTextViewModel >> onTextChanged: anAnnouncement [
	self
		announce: (GtFilterTextViewModelTextChanged new
				viewModel: self;
				text: anAnnouncement text)
]

{ #category : #'api - filter model' }
GtFilterTextViewModel >> subscribeToFilterModel [
	super subscribeToFilterModel.
	self filterModel weak
		when: GtFilterTextModelTextChanged
			send: #onTextChanged:
			to: self;
		when: GtFilterTextModelInputFilterChanged
			send: #onInputFilterChanged:
			to: self
]

{ #category : #testing }
GtFilterTextViewModel >> text [
	^ self filterModel text
]
