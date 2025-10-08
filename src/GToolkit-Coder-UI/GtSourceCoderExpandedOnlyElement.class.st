Class {
	#name : #GtSourceCoderExpandedOnlyElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtWithTextualCoderViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtWithTextualCoderViewModel classTrait',
	#instVars : [
		'expandedElement',
		'modificationIndicator'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #converting }
GtSourceCoderExpandedOnlyElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #'api - textual coder view model' }
GtSourceCoderExpandedOnlyElement >> coderViewModel [
	^ self textualCoderViewModel
]

{ #category : #'api - textual coder view model' }
GtSourceCoderExpandedOnlyElement >> coderViewModel: aViewModel [
	self textualCoderViewModel: aViewModel
]

{ #category : #initialization }
GtSourceCoderExpandedOnlyElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'focus requesting' }
GtSourceCoderExpandedOnlyElement >> focusTarget [
	^ expandedElement focusTarget
]

{ #category : #initialization }
GtSourceCoderExpandedOnlyElement >> initialize [
	super initialize.
	self
		hMatchParent;
		vFitContent.

	expandedElement := self newExpandedElement.
	modificationIndicator := self newModificationIndicator.
	modificationIndicator visibility: BlVisibility gone.
	
	self addChild: expandedElement.
	self addChild: modificationIndicator.

	self addAptitude: (BrLayoutResizerAptitude new common: expandedElement)
]

{ #category : #initialization }
GtSourceCoderExpandedOnlyElement >> newExpandedElement [
	^ GtSourceCoderExpandedContentElement new
		showScrollbars;
		yourself
]

{ #category : #initialization }
GtSourceCoderExpandedOnlyElement >> newModificationIndicator [
	^ GtSourceCoderModificationIndicator new
		withVerticalLeftIgnoredLayout;
		margin: (BlInsets all: 0)
]

{ #category : #'api - textual coder view model' }
GtSourceCoderExpandedOnlyElement >> onTextualCoderViewModelChanged [
	"Is sent when a new textualCoder view model is assigned to the element.
	Note: #onTextualCoderViewModelChanged is sent before #subscribeToTextualCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostTextualCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	self textualCoderViewModel expanded: true.
	expandedElement textualCoderViewModel: self textualCoderViewModel.
	modificationIndicator textualCoderViewModel: self textualCoderViewModel.
	
	self updateElement
]

{ #category : #'private - updating' }
GtSourceCoderExpandedOnlyElement >> updateElement [
	self textualCoderViewModel coderLook
		ifNotNil: [ :aNewAptitude | 
			expandedElement userData
				at: #coderAptitude
				ifPresent: [ :anOldAptitude | expandedElement removeAptitude: anOldAptitude ]
				ifAbsent: [  ].

			expandedElement addAptitude: aNewAptitude.
			
			expandedElement userData
				at: #coderAptitude
				put: aNewAptitude ]
]
