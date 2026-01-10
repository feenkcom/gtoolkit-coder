Class {
	#name : #GtSourceCoderElement,
	#superclass : #GtTextualCoderElement,
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #views }
GtSourceCoderElement >> gtEditorTextAttributesFor: aView [
	<gtView>
	^ aView forward
		title: 'Text attributes';
		priority: 41;
		object: [ self editor ];
		view: #gtTextAttributesFor:
]

{ #category : #views }
GtSourceCoderElement >> gtEditorTextIntervalsFor: aView [
	<gtView>
	^ aView forward
		title: 'Text intervals';
		priority: 42;
		object: [ self editor ];
		view: #gtTextIntervalsFor:
]

{ #category : #initalization }
GtSourceCoderElement >> initialize [
	super initialize.
	self editor doubleClickWordClassifier: GtSmalltalkSourceCoder doubleClickClassifier.
	self editor movementWordClassifier: GtSmalltalkSourceCoder wordMovementClassifier.
]

{ #category : #'api - textual coder view model' }
GtSourceCoderElement >> onTextualCoderViewModelChanged [
	super onTextualCoderViewModelChanged.
	
	self textualCoderViewModel evaluationResult
		ifNil: [ evaluationHighlighter hideResult ]
		ifNotNil: [ :aResult | evaluationHighlighter displayResult: aResult ]
]

{ #category : #registration }
GtSourceCoderElement >> onViewModelEvaluationStatusChanged: anAnnouncement [
	self
		enqueueTask: (BlTaskAction new
				action: [ anAnnouncement evaluationStatus
						handleStatusChangedAnnouncement: anAnnouncement
						sourceCoderElement: self.
					self styleText ])
]

{ #category : #registration }
GtSourceCoderElement >> registerCoderViewModelAnnouncementsFor: aGtSourceCoderUIModel [
	super registerCoderViewModelAnnouncementsFor: aGtSourceCoderUIModel.
	aGtSourceCoderUIModel weak
		when: GtSourceCoderViewModelEvaluationStatusChanged
		send: #onViewModelEvaluationStatusChanged:
		to: self
]
