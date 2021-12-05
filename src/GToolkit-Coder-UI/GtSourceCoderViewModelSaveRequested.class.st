"
Is announced by the {{gtClass:GtSourceCoderViewModel}} when a save is requested. If the announcement is not consumed, the save will happen in a default context
"
Class {
	#name : #GtSourceCoderViewModelSaveRequested,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'consumed'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Events'
}

{ #category : #accessing }
GtSourceCoderViewModelSaveRequested >> consumed [
	<return: #Boolean>

	^ consumed
]

{ #category : #accessing }
GtSourceCoderViewModelSaveRequested >> consumed: aBoolean [
	"Prevents the default save action, when set to true by the event handler"

	consumed := aBoolean
]

{ #category : #initialization }
GtSourceCoderViewModelSaveRequested >> initialize [
	super initialize.
	
	consumed := false
]
