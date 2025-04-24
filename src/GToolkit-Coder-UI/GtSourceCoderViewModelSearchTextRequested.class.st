Class {
	#name : #GtSourceCoderViewModelSearchTextRequested,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'consumed'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Events'
}

{ #category : #accessing }
GtSourceCoderViewModelSearchTextRequested >> consumed [
	<return: #Boolean>

	^ consumed
]

{ #category : #accessing }
GtSourceCoderViewModelSearchTextRequested >> consumed: aBoolean [
	"Prevents the default save action, when set to true by the event handler"

	consumed := aBoolean
]

{ #category : #initialization }
GtSourceCoderViewModelSearchTextRequested >> initialize [
	super initialize.
	
	consumed := false
]
