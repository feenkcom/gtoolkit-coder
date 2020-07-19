Class {
	#name : #GtSourceCoderContentElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#category : #'GToolkit-Coder-UI - Source Coder'
}

{ #category : #accessing }
GtSourceCoderContentElement >> coder [
	<return: #GtCoderModel>

	^ self viewModel sourceCoder
]

{ #category : #accessing }
GtSourceCoderContentElement >> coder: aCoder [

	self telemetry
		timeSync: [ 'Assign coder to {1}' format: { self class name } ]
		during: [ self viewModel sourceCoder: aCoder ]
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
		margin: (BlInsets left: 5).

	self viewModel: (GtSourceCoderContentModel new add: (BrInteractiveModel new addStates: {
		BrLayoutHorizontalResizerModel matchParent.
		BrLayoutVerticalResizerModel fitContentLimited }))
]
