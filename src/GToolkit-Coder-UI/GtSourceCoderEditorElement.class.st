Class {
	#name : #GtSourceCoderEditorElement,
	#superclass : #GtTextualCoderEditorElement,
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #initalization }
GtSourceCoderEditorElement >> initialize [
	super initialize.
	self editor doubleClickWordClassifier: BrSmalltalkWordClassifier new.
	self editor movementWordClassifier: BrCamelCaseWordClassifier new.
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
