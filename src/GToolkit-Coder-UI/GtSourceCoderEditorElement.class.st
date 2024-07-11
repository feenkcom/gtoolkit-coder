Class {
	#name : #GtSourceCoderEditorElement,
	#superclass : #GtTextualCoderEditorElement,
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #'api - textual coder view model' }
GtSourceCoderEditorElement >> onTextualCoderViewModelChanged [
	super onTextualCoderViewModelChanged.
	
	self textualCoderViewModel evaluationResult
		ifNil: [ evaluationHighlighter hideResult ]
		ifNotNil: [ :aResult | evaluationHighlighter displayResult: aResult ]
]

{ #category : #registration }
GtSourceCoderEditorElement >> onViewModelEvaluationStatusChanged: anAnnouncement [
	BlTaskAction
		enqueueElement: self
		action: [ anAnnouncement evaluationStatus
				handleStatusChangedAnnouncement: anAnnouncement
				sourceCoderElement: self.
			self styleText ]
]

{ #category : #registration }
GtSourceCoderEditorElement >> registerCoderViewModelAnnouncementsFor: aGtSourceCoderUIModel [
	super registerCoderViewModelAnnouncementsFor: aGtSourceCoderUIModel.
	aGtSourceCoderUIModel weak
		when: GtSourceCoderViewModelEvaluationStatusChanged
		send: #onViewModelEvaluationStatusChanged:
		to: self
]
