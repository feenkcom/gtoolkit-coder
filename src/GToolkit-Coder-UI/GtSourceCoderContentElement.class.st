Class {
	#name : #GtSourceCoderContentElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
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

	self telemetry
		timeSync: [ 'Assign coder to {1}' format: { self class name } ]
		during: [ self viewModel sourceCoder: aGtSourceCoderUIModel ]
]

{ #category : #accessing }
GtSourceCoderContentElement >> gtAllShortcutsFor: aView [
	<gtView>
	self shortcuts ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'All shortcuts' translated;
		priority: 10;
		items: [ self shortcuts , self coder addOns shortcuts ];
		column: 'Key' item: [ :each | each combination gtDisplayString ];
		column: 'Action' item: [ :each | each action asString ]
]

{ #category : #initialization }
GtSourceCoderContentElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		margin: (BlInsets left: 5);
		hMatchParent;
		vFitContentLimited.

	self viewModel: (GtSourceCoderContentModel new)
]
