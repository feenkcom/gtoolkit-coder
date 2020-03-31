Class {
	#name : #GtCodeDefinition,
	#superclass : #Object,
	#instVars : [
		'headerModel',
		'announcer',
		'parent'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'announcer - subscription' }
GtCodeDefinition >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #'announcer - subscription' }
GtCodeDefinition >> dispatchEvent: anEvent [
	self announcer announce: anEvent
]

{ #category : #'gt - editors' }
GtCodeDefinition >> editors [
	<return: #Collection of: #GtCodeDefinitionEditor>
	
	^ #()
]

{ #category : #'gt-extension' }
GtCodeDefinition >> gtEditorsFor: aView [
	<gtView>
	
	self editors
		ifEmpty: [ ^ aView empty ].
	
	^ aView list
		title: 'Editors';
		priority: 8;
		items: [ self editors ]
]

{ #category : #testing }
GtCodeDefinition >> hasParent [
	<return: #Boolean>

	^ parent isNotNil
]

{ #category : #accessing }
GtCodeDefinition >> parent [
	^ parent
]

{ #category : #accessing }
GtCodeDefinition >> parent: anObject [
	parent := anObject
]

{ #category : #'announcer - subscription' }
GtCodeDefinition >> when: anEventClass do: aBlock [
	self announcer when: anEventClass do: aBlock
]
