Class {
	#name : #GtCodeDefinition,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'parent'
	],
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'announcer - subscription' }
GtCodeDefinition >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #converting }
GtCodeDefinition >> asDefinitionString [
	^ ''
]

{ #category : #'api - accepting' }
GtCodeDefinition >> differenceWith: aGtCodeDefinition [
	<return: #GtCodeDefinitionDifference>

	^ GtNoDefinitionDifference new
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
GtCodeDefinition >> gtDefinitionFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Definition';
		priority: 1;
		text: [ self asDefinitionString ]
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
