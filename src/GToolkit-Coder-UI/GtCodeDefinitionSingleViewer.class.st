Class {
	#name : #GtCodeDefinitionSingleViewer,
	#superclass : #GtCodeDefinitionEntityViewer,
	#instVars : [
		'getSelector',
		'renameAnnouncement'
	],
	#category : #'GToolkit-Coder-UI-Behaviour - Editor / Reader'
}

{ #category : #'api - instantiation' }
GtCodeDefinitionSingleViewer >> create [
	<return: #Object>

	^ self subclassResponsibility
]

{ #category : #accessing }
GtCodeDefinitionSingleViewer >> getSelector [
	^ getSelector
]

{ #category : #accessing }
GtCodeDefinitionSingleViewer >> getSelector: anObject [
	getSelector := anObject
]

{ #category : #accessing }
GtCodeDefinitionSingleViewer >> renameEvent: anObject [
	renameAnnouncement := anObject
]
