Class {
	#name : #GtSourceCoderContentElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtWithTextualCoderViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtWithTextualCoderViewModel classTrait',
	#instVars : [
		'header'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #accessing }
GtSourceCoderContentElement >> coder [
	self 
		deprecated: 'Use #coderUIModel instead.'
		transformWith: '`@receiver coder' -> '`@receiver coderUIModel'.
		
	^ self coderUIModel
]

{ #category : #accessing }
GtSourceCoderContentElement >> coder: aCoder [

	self 
		deprecated: 'Use #coderUIModel: instead.'
		transformWith: '`@receiver coder: `@arg' -> '`@receiver coderUIModel: `@arg'.
		
	self coderUIModel: aCoder
]

{ #category : #accessing }
GtSourceCoderContentElement >> coderUIModel [
	<return: #GtSourceCoderViewModel>

	^ self viewModel sourceCoder
]

{ #category : #accessing }
GtSourceCoderContentElement >> coderUIModel: aGtSourceCoderUIModel [

	BlFrameTelemetry
		time: [ 'Assign coder to {1}' format: { self class name } ]
		during: [ self textualCoderViewModel: aGtSourceCoderUIModel ]
]

{ #category : #initialization }
GtSourceCoderContentElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #accessing }
GtSourceCoderContentElement >> gtAllShortcutsFor: aView [
	<gtView>
	self shortcuts ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'All shortcuts' translated;
		priority: 10;
		items: [ self shortcuts , self coder addOns shortcuts ];
		column: 'Key' text: [ :each | each combination gtDisplayString ];
		column: 'Action' text: [ :each | each action asString ]
]

{ #category : #initialization }
GtSourceCoderContentElement >> initialize [
	super initialize.
	self
		margin: (BlInsets left: 5);
		hMatchParent;
		vFitContentLimited
]

{ #category : #initialization }
GtSourceCoderContentElement >> newHeaderElement [
	^ self textualCoderViewModel headerElementClass new
		constraintsDo: [ :c | 
			c margin: (BlInsets top: 2).
			c frame horizontal alignLeft.
			c frame vertical alignCenter ];
		yourself
]

{ #category : #'api - textual coder view model' }
GtSourceCoderContentElement >> onTextualCoderViewModelChanged [
	"Is sent when a new textualCoder view model is assigned to the element.
	Note: #onTextualCoderViewModelChanged is sent before #subscribeToTextualCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostTextualCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	textualCoderViewModel wantsHeader
		ifTrue: [
			header ifNil: [
				header := self newHeaderElement.
				self addChildFirst: header ].
			header textualCoderViewModel: textualCoderViewModel.
			header visibility: BlVisibility visible ]
		ifFalse: [ header ifNotNil: [ :aHeader | aHeader visibility: BlVisibility gone ] ]
]
