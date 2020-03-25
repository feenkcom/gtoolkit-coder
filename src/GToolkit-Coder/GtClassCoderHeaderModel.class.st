Class {
	#name : #GtClassCoderHeaderModel,
	#superclass : #BrWidgetModel,
	#instVars : [
		'theClass',
		'definition'
	],
	#category : #'GToolkit-Coder-Class - Model'
}

{ #category : #'api - modification' }
GtClassCoderHeaderModel >> addInstVarNamed: aString [
	| aNewInstanceVariable |
	
	aNewInstanceVariable := definition addInstVarNamed: aString.
	self notifyInstVarAdded: aNewInstanceVariable
]

{ #category : #'gt-extension' }
GtClassCoderHeaderModel >> gtInstanceVariablesFor: aView [
	<gtView>
	^ aView list
		title: 'InstVars';
		priority: 5;
		items: [ self instanceVariables ];
		itemFormat: [ :each | each name ]
]

{ #category : #initialization }
GtClassCoderHeaderModel >> initialize [
	super initialize.
	
	self theClass: Class new
]

{ #category : #initialization }
GtClassCoderHeaderModel >> initializeListeners [
	super initializeListeners.
	
	self when: GtClassCoderHeaderInstVarsRequest reply: [ :aResponse | aResponse instanceVariables: definition instanceVariables ].

	self when: GtClassCoderHeaderAddInstVarWish do: [ :aWish | self addInstVarNamed: aWish name ].
	self when: GtClassCoderHeaderRemoveInstVarWish do: [ :aWish | self removeInstVarNamed: aWish name ].
	self when: GtClassCoderHeaderRenameInstVarWish do: [ :aWish | self renameInstVarNamed: aWish oldName to: aWish newName ]
]

{ #category : #accessing }
GtClassCoderHeaderModel >> instanceVariables [
	^ definition instanceVariables
]

{ #category : #'private - notifying' }
GtClassCoderHeaderModel >> notifyInstVarAdded: anInstanceVariable [
	self dispatchEvent: (GtClassCoderHeaderInstVarAdded new instanceVariable: anInstanceVariable)
]

{ #category : #'private - notifying' }
GtClassCoderHeaderModel >> notifyInstVarRemoved: anInstanceVariable [
	self dispatchEvent: (GtClassCoderHeaderInstVarRemoved new instanceVariable: anInstanceVariable)
]

{ #category : #'private - notifying' }
GtClassCoderHeaderModel >> notifyInstVarRenamed: anInstanceVariable from: anOldName to: aNewName [
	self dispatchEvent: (GtClassCoderHeaderInstVarRenamed new
		instanceVariable: anInstanceVariable;
		oldName: anInstanceVariable;
		newName: aNewName)
]

{ #category : #'api - modification' }
GtClassCoderHeaderModel >> removeInstVarNamed: aString [
	| aRemovedInstanceVariable |

	aRemovedInstanceVariable := definition instanceVariableNamed: aString.
	definition removeInstanceVariable: aRemovedInstanceVariable.
	self notifyInstVarRemoved: aRemovedInstanceVariable
]

{ #category : #'api - modification' }
GtClassCoderHeaderModel >> renameInstVarNamed: aCurrentName to: aNewName [
	| aRenamedInstanceVariable |

	aRenamedInstanceVariable := definition instanceVariableNamed: aCurrentName.
	aRenamedInstanceVariable name: aNewName.
	
	self
		notifyInstVarRenamed: aRenamedInstanceVariable
		from: aCurrentName
		to: aNewName
]

{ #category : #accessing }
GtClassCoderHeaderModel >> theClass [
	^ theClass
]

{ #category : #accessing }
GtClassCoderHeaderModel >> theClass: aClass [
	theClass := aClass.
	definition := aClass asRingDefinition
]
