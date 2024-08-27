Class {
	#name : #GtFilterTextViewModel,
	#superclass : #GtFilterViewModel,
	#category : #'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #accessing }
GtFilterTextViewModel >> filterElementClass [
	^ GtFilterTextSettingsElement
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
		to: self
]

{ #category : #testing }
GtFilterTextViewModel >> text [
	^ self filterModel text
]

{ #category : #'api - filter model' }
GtFilterTextViewModel >> unsubscribeFromFilterModel [
	super unsubscribeFromFilterModel.
	self filterModel unsubscribe: self
]
