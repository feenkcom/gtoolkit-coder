Class {
	#name : #GtSourceCoderViewModelSearchTextCancelRequested,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'consumed'
	],
	#category : 'GToolkit-Coder-UI-Coder - Source Events'
}

{ #category : #accessing }
GtSourceCoderViewModelSearchTextCancelRequested >> consumed [
	<return: #Boolean>

	^ consumed
]

{ #category : #accessing }
GtSourceCoderViewModelSearchTextCancelRequested >> consumed: aBoolean [
	"Prevents the default save action, when set to true by the event handler"

	consumed := aBoolean
]

{ #category : #initialization }
GtSourceCoderViewModelSearchTextCancelRequested >> initialize [
	super initialize.
	
	consumed := false
]
