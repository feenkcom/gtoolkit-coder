Class {
	#name : #GtCodeDefinitionPluralViewer,
	#superclass : #GtCodeDefinitionEntityViewer,
	#instVars : [
		'separatorStencil',
		'getSelector',
		'addAnnouncement',
		'removeAnnouncement',
		'renameAnnouncement'
	],
	#category : #'GToolkit-Coder-UI-Behaviour - Editor / Reader'
}

{ #category : #accessing }
GtCodeDefinitionPluralViewer >> addEvent: anObject [
	addAnnouncement := anObject
]

{ #category : #'api - instantiation' }
GtCodeDefinitionPluralViewer >> create [
	<return: #Object>
	
	^ self subclassResponsibility
]

{ #category : #accessing }
GtCodeDefinitionPluralViewer >> getSelector [
	^ getSelector
]

{ #category : #accessing }
GtCodeDefinitionPluralViewer >> getSelector: anObject [
	getSelector := anObject
]

{ #category : #initialization }
GtCodeDefinitionPluralViewer >> initialize [
	super initialize.
	
	"no separator by default"
	separatorStencil := nil
]

{ #category : #accessing }
GtCodeDefinitionPluralViewer >> removeEvent: anObject [
	removeAnnouncement := anObject
]

{ #category : #accessing }
GtCodeDefinitionPluralViewer >> renameEvent: anObject [
	renameAnnouncement := anObject
]

{ #category : #accessing }
GtCodeDefinitionPluralViewer >> separator: aStencil [
	separatorStencil := aStencil asStencil
]
