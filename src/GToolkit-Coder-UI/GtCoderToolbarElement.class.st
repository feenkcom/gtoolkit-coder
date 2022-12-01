"
I display a {{gtClass:BrToolbar}}.
1. # Example

{{gtExample:GtCoderElementExamples>>#toolbarElementWithClass|previewExpanded|codeExpanded=false|previewHeight=700}}


"
Class {
	#name : #GtCoderToolbarElement,
	#superclass : #GtCoderNavigationModelElement,
	#instVars : [
		'toolbarElement'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #initialization }
GtCoderToolbarElement >> addCustomButtons [
	| classToUse |
	classToUse := self navigationModel hasSelectedClass
			ifTrue: [ self navigationModel selectedClass ]
			ifFalse: [ self navigationModel hasSelectedPackage
					ifTrue: [ self navigationModel selectedPackage ]
					ifFalse: [ self class ] ].
	(GtPhlowClassActionsCollector new
		pragmaName: #gtClassAction;
		from: classToUse class;
		to: Behavior;
		collect)
		do: [ :each | 
			each
				asElement: [ :actionElement | self toolbarElement addItem: actionElement ]
				withHostElement: self ]
]

{ #category : #initialization }
GtCoderToolbarElement >> initialize [
	super initialize.
	self initializeToolbarElement.
	
	self layout: BlLinearLayout horizontal.

	self addChild: self toolbarElement as: #toolbar.
	
	self addAptitude: (BrLayoutResizerAptitude new
		anyToFitContent;
		anyToFitContent: self toolbarElement)
]

{ #category : #initialization }
GtCoderToolbarElement >> initializeToolbarElement [
	toolbarElement := BrToolbar new
			aptitude: BrGlamorousToolbarAptitude new;
			padding: (BlInsets right: 5).
]

{ #category : #initialization }
GtCoderToolbarElement >> onNavigationModelChanged [
	self updateCustomButtons
]

{ #category : #accessing }
GtCoderToolbarElement >> toolbarElement [
	<return: #BrToolbar>
	^ toolbarElement
]

{ #category : #initialization }
GtCoderToolbarElement >> updateCustomButtons [
	toolbarElement removeChildren.
	self addCustomButtons
]
