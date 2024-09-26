Class {
	#name : #GtFilterTextSettingsElement,
	#superclass : #GtFilterSettingsElement,
	#instVars : [
		'editorElement'
	],
	#category : #'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #initialization }
GtFilterTextSettingsElement >> initialize [
	super initialize.
	self initializeEditorElement.
	self addChild: editorElement as: #editor
]

{ #category : #initialization }
GtFilterTextSettingsElement >> initializeEditorElement [
	editorElement := BrEditor new
			hFitContentLimited;
			vFitContent;
			background: self theme default contentBackgroundColor;
			aptitude: BrGlamorousRegularEditorAptitude new 
				glamorousRegularSmallSize;
			text: '';
			padding: (BlInsets top: 1 right: 2 bottom: 1 left: 2)
]

{ #category : #'api - filter view model' }
GtFilterTextSettingsElement >> onFilterViewModelChanged [
	super onFilterViewModelChanged.

	self updateEditorElement
]

{ #category : #'event handling' }
GtFilterTextSettingsElement >> onInputFilterChanged: anAnnouncement [
	BlTaskAction 
		enqueueElement: self 
		action: [ self updateEditorElementInputFilter ]
]

{ #category : #'event handling' }
GtFilterTextSettingsElement >> onTextChanged: anAnnouncement [
	BlTaskAction 
		enqueueElement: self 
		action: [ self updateEditorElementText ]
]

{ #category : #'api - filter view model' }
GtFilterTextSettingsElement >> subscribeToFilterViewModel [
	super subscribeToFilterViewModel.

	self filterViewModel weak
		when: GtFilterTextViewModelTextChanged
			send: #onTextChanged:
			to: self;
		when: GtFilterTextViewModelInputFilterChanged
			send: #onInputFilterChanged:
			to: self
]

{ #category : #'private - updating' }
GtFilterTextSettingsElement >> updateEditorElement [
	self updateEditorElementInputFilter.
	self updateEditorElementText.
]

{ #category : #'private - updating' }
GtFilterTextSettingsElement >> updateEditorElementInputFilter [
	(editorElement editor inputFilter = self filterViewModel inputFilter)
		ifTrue: [ ^ self ].
	
	editorElement inputFilter: self filterViewModel inputFilter
]

{ #category : #'private - updating' }
GtFilterTextSettingsElement >> updateEditorElementText [
	(editorElement text equals: self filterViewModel text)
		ifTrue: [ ^ self ].
	
	editorElement text: self filterViewModel text copy
]
