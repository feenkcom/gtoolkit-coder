Class {
	#name : #GtSourceCoderEditorElement,
	#superclass : #GtTextualCoderEditorElement,
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #views }
GtSourceCoderEditorElement >> gtEditorTextAttributesFor: aView [
	<gtView>
	^ aView forward
		title: 'Text attributes';
		priority: 41;
		object: [ self editor ];
		view: #gtTextAttributesFor:
]

{ #category : #views }
GtSourceCoderEditorElement >> gtEditorTextIntervalsFor: aView [
	<gtView>
	^ aView forward
		title: 'Text intervals';
		priority: 42;
		object: [ self editor ];
		view: #gtTextIntervalsFor:
]

{ #category : #views }
GtSourceCoderEditorElement >> gtView1For: aView [
	<gtView>
	^ aView forward
		title: 'Text intervals';
		priority: 42;
		object: [ self editor ];
		view: #gtTextIntervalsFor:
]

{ #category : #initalization }
GtSourceCoderEditorElement >> initialize [
	super initialize.
	self editor doubleClickWordClassifier: GtSmalltalkSourceCoder doubleClickClassifier.
	self editor movementWordClassifier: GtSmalltalkSourceCoder wordMovementClassifier.
]

{ #category : #'api - textual coder view model' }
GtSourceCoderEditorElement >> onTextualCoderViewModelChanged [
	super onTextualCoderViewModelChanged.
	
	self textualCoderViewModel evaluationResult
		ifNil: [ evaluationHighlighter hideResult ]
		ifNotNil: [ :aResult | evaluationHighlighter displayResult: aResult ]
]

{ #category : #'as yet unclassified' }
GtSourceCoderEditorElement >> onUpdateAddOnsRequest: aGtCoderAddOnsUpdateRequest [ 
	"To be deleted"
]

{ #category : #registration }
GtSourceCoderEditorElement >> onViewModelEvaluationStatusChanged: anAnnouncement [
	self
		enqueueTask: (BlTaskAction new
				action: [ anAnnouncement evaluationStatus
						handleStatusChangedAnnouncement: anAnnouncement
						sourceCoderElement: self.
					self styleText ])
]

{ #category : #registration }
GtSourceCoderEditorElement >> registerCoderViewModelAnnouncementsFor: aGtSourceCoderUIModel [
	super registerCoderViewModelAnnouncementsFor: aGtSourceCoderUIModel.
	aGtSourceCoderUIModel weak
		when: GtSourceCoderViewModelEvaluationStatusChanged
		send: #onViewModelEvaluationStatusChanged:
		to: self
]
