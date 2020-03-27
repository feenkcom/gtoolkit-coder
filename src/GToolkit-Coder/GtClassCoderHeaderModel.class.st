Class {
	#name : #GtClassCoderHeaderModel,
	#superclass : #BrWidgetModel,
	#instVars : [
		'theClass',
		'definition'
	],
	#category : #'GToolkit-Coder-Class - Model'
}

{ #category : #'api - class vars' }
GtClassCoderHeaderModel >> addClassVarNamed: aString [
	| aNewClassVariable |
	
	aNewClassVariable := definition addClassVarNamed: aString.
	self notifyClassVarAdded: aNewClassVariable
]

{ #category : #'api - inst vars' }
GtClassCoderHeaderModel >> addInstVarNamed: aString [
	| aNewInstanceVariable |
	
	aNewInstanceVariable := definition addInstVarNamed: aString.
	self notifyInstVarAdded: aNewInstanceVariable
]

{ #category : #'api - class vars' }
GtClassCoderHeaderModel >> classVarNames [
	<return: #Collection of: #String>

	^ definition classVarNames
]

{ #category : #'api - class vars' }
GtClassCoderHeaderModel >> classVariables [
	^ definition classVariables
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

{ #category : #'api - inst vars' }
GtClassCoderHeaderModel >> instVarNames [
	<return: #Collection of: #String>

	^ definition instVarNames
]

{ #category : #'api - inst vars' }
GtClassCoderHeaderModel >> instanceVariables [
	^ definition instanceVariables
]

{ #category : #'private - notifying' }
GtClassCoderHeaderModel >> notifyClassChanged: aClass [
	self dispatchEvent: (GtClassCoderHeaderClassChanged new theClass: aClass)
]

{ #category : #'private - notifying' }
GtClassCoderHeaderModel >> notifyClassVarAdded: aClassVariable [
	self dispatchEvent: (GtClassCoderHeaderClassVarAdded new classVariable: aClassVariable)
]

{ #category : #'private - notifying' }
GtClassCoderHeaderModel >> notifyClassVarRemoved: aClassVariable [
	self dispatchEvent: (GtClassCoderHeaderClassVarRemoved new classVariable: aClassVariable)
]

{ #category : #'private - notifying' }
GtClassCoderHeaderModel >> notifyClassVarRenamed: aClassVariable from: anOldName to: aNewName [
	self dispatchEvent: (GtClassCoderHeaderClassVarRenamed new
		classVariable: aClassVariable;
		oldName: anOldName;
		newName: aNewName)
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
		oldName: anOldName;
		newName: aNewName)
]

{ #category : #'api - package / tag' }
GtClassCoderHeaderModel >> packageName [
	<return: #String>
	
	
]

{ #category : #'api - class vars' }
GtClassCoderHeaderModel >> removeClassVarNamed: aString [
	| aRemovedClassVariable |

	aRemovedClassVariable := definition classVarNamed: aString.
	definition removeClassVariable: aRemovedClassVariable.
	self notifyClassVarRemoved: aRemovedClassVariable
]

{ #category : #'api - inst vars' }
GtClassCoderHeaderModel >> removeInstVarNamed: aString [
	| aRemovedInstanceVariable |

	aRemovedInstanceVariable := definition instanceVariableNamed: aString.
	definition removeInstanceVariable: aRemovedInstanceVariable.
	self notifyInstVarRemoved: aRemovedInstanceVariable
]

{ #category : #'api - class vars' }
GtClassCoderHeaderModel >> renameClassVarNamed: aCurrentName to: aNewName [
	| aRenamedClassVariable |

	aRenamedClassVariable := definition classVarNamed: aCurrentName.
	aRenamedClassVariable name: aNewName.
	
	self
		notifyClassVarRenamed: aRenamedClassVariable
		from: aCurrentName
		to: aNewName
]

{ #category : #'api - inst vars' }
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
	definition := aClass asRingDefinition.
	definition superclass: aClass superclass.
	
	self notifyClassChanged: aClass
]

{ #category : #'api - superclass' }
GtClassCoderHeaderModel >> theSuperclass [
	<return: #Class>

	^ definition superclass
]

{ #category : #'api - superclass' }
GtClassCoderHeaderModel >> theSuperclassName [
	<return: #String>

	^ definition superclass name
]
