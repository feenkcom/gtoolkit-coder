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
			text: ''
]

{ #category : #'as yet unclassified' }
GtFilterTextSettingsElement >> onFilterViewModelChanged [
	super onFilterViewModelChanged.

	self updateEditorElement
]

{ #category : #'event handling' }
GtFilterTextSettingsElement >> onTextChanged: anAnnouncement [
	BlTaskAction 
		enqueueElement: self 
		action: [ self updateEditorElement ]
]

{ #category : #'api - filter view model' }
GtFilterTextSettingsElement >> subscribeToFilterViewModel [
	super subscribeToFilterViewModel.

	self filterViewModel weak
		when: GtFilterTextModelTextChanged
		send: #onTextChanged:
		to: self
]

{ #category : #'private - updating' }
GtFilterTextSettingsElement >> updateEditorElement [
	editorElement text: self filterViewModel text copy
]
