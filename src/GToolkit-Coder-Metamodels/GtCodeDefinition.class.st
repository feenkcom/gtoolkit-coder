Class {
	#name : #GtCodeDefinition,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'parent'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Definitions'
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
	self announcer announce: anEvent.
	parent notNil ifTrue: [ parent dispatchEvent: anEvent ]
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
