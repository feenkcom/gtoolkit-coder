Class {
	#name : #GtClassVariablesDefinition,
	#superclass : #GtCompositeDefinition,
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtClassVariablesDefinition class >> fromClass: aClass [
	^ self new fromClass: aClass
]

{ #category : #'instance creation' }
GtClassVariablesDefinition class >> fromTrait: aTrait [
	^ self new fromTrait: aTrait
]

{ #category : #'api - class vars' }
GtClassVariablesDefinition >> addClassVariableNamed: aSymbol [
	| aClassVariableName aNewClassVariable |
	
	aClassVariableName := aSymbol asSymbol.
	
	(self hasDefinitionNamed: aClassVariableName)
		ifTrue: [ self errorClassVariableAlreadyExists: aClassVariableName ].

	aNewClassVariable := GtVariableDefinition named: aClassVariableName.
	definitions := definitions copyWith: aNewClassVariable.

	self notifyClassVariableAdded: aNewClassVariable
]

{ #category : #converting }
GtClassVariablesDefinition >> asDefinitionString [
	self isEmpty
		ifTrue: [ ^ '{ }' ].

	^ String streamContents: [ :aStream | 
		aStream nextPutAll: '{ '.
	
		definitions do: [ :eachVariable | aStream nextPutAll: eachVariable asDefinitionString ]
			separatedBy: [ 
				aStream nextPutAll: '. ' ].		
		definitions ifNotEmpty: [ aStream nextPutAll: '.'  ].
		aStream nextPutAll: ' }'. ]
]

{ #category : #'api - class vars' }
GtClassVariablesDefinition >> classVariableNamed: aSymbol [
	<return: #GtVariableDefinition>
	
	^ self
		definitionNamed: aSymbol 
		ifNone: [ self errorClassVariableNotFound: aSymbol ]
]

{ #category : #'gt - editors' }
GtClassVariablesDefinition >> classVariablesEditor [
	<return: #GtCodeDefinitionEditor>
	
	^ GtCodeDefinitionPluralEditor new
			definition: self;
			title: 'Class vars';
			addSelector: #addClassVariableNamed:;
			removeSelector: #removeClassVariableNamed:;
			renameSelector: #renameClassVariableNamed:to:;
			getSelector: #names;
			modelSelector: #classVariableNamed:;
			addEvent: GtBehaviorClassVariableAdded;
			removeEvent: GtBehaviorClassVariableRemoved;
			renameEvent: GtBehaviorClassVariableRenamed;
			whenKey: BlKeyCombination primaryI do: [ :anEvent :aDefinition  | aDefinition inspectFrom: anEvent ];
			whenKey: BlKeyCombination primaryB do: [ :anEvent :aDefinition  | aDefinition browseFrom: anEvent ];
			whenPrimaryClickDo: [ :anEvent :aDefinition | aDefinition browseFrom: anEvent ]
]

{ #category : #'api - accepting' }
GtClassVariablesDefinition >> differenceWith: aGtClassVariablesDefinition [
	| theDifference |

	theDifference := GtClassVariablesDefinitionDifference new.

	GtCodeDefinitionDifference
		difference: self all
		with: aGtClassVariablesDefinition all
		addedDo: [ :eachClassVariable | theDifference add: (GtClassVariableAddedDifference new classVariableName: eachClassVariable name) ]
		renamedDo: [ :eachClassVariable | theDifference add: (GtClassVariableRenamedDifference new
			classVariableName: eachClassVariable originalName;
			oldName: eachClassVariable originalName;
			newName: eachClassVariable name) ]
		removedDo: [ :eachClassVariable | theDifference add: (GtClassVariableRemovedDifference new classVariableName: eachClassVariable name) ].
		
	^ theDifference
]

{ #category : #'gt - editors' }
GtClassVariablesDefinition >> editors [
	^ { self classVariablesEditor }
]

{ #category : #'private - errors' }
GtClassVariablesDefinition >> errorClassVariableAlreadyExists: aSymbol [ 
	"Create an error notification that there is already a class variable with a given name"

	GtBehaviorCoderHeaderClassVariableAlreadyExistsError signalFor: aSymbol
]

{ #category : #'private - errors' }
GtClassVariablesDefinition >> errorClassVariableNotFound: aSymbol [ 
	"Create an error notification that there is no class variable with a given name"

	GtBehaviorCoderHeaderClassVariableNotFoundError signalFor: aSymbol
]

{ #category : #initialization }
GtClassVariablesDefinition >> fromClass: aClass [
	definitions := aClass classVariables collect: [ :eachClassVariable | (GtVariableDefinition fromClassVariable: eachClassVariable) parent: self ]
]

{ #category : #initialization }
GtClassVariablesDefinition >> fromTrait: aTrait [
	definitions := aTrait classVariables collect: [ :eachClassVariable | (GtVariableDefinition fromClassVariable: eachClassVariable) parent: self ]
]

{ #category : #'private - notifying' }
GtClassVariablesDefinition >> notifyClassVariableAdded: aGtVariableDefinition [
	self dispatchEvent: (GtBehaviorClassVariableAdded new
		classVariable: aGtVariableDefinition;
		owner: self parent)
]

{ #category : #'private - notifying' }
GtClassVariablesDefinition >> notifyClassVariableRemoved: aGtVariableDefinition [
	self dispatchEvent: (GtBehaviorClassVariableRemoved new
		classVariable: aGtVariableDefinition;
		owner: self parent)
]

{ #category : #'private - notifying' }
GtClassVariablesDefinition >> notifyClassVariableRenamed: aGtVariableDefinition from: anOldName to: aNewName [
	self dispatchEvent: (GtBehaviorClassVariableRenamed new
		classVariable: aGtVariableDefinition;
		owner: self parent;
		oldName: anOldName;
		newName: aNewName)
]

{ #category : #'api - class vars' }
GtClassVariablesDefinition >> removeClassVariableNamed: aSymbol [
	| aRemovedClassVariable |
	
	(self hasDefinitionNamed: aSymbol)
		ifFalse: [ self errorClassVariableNotFound: aSymbol ].
	
	aRemovedClassVariable := self classVariableNamed: aSymbol.
	definitions := definitions copyWithout: aRemovedClassVariable.
	self notifyClassVariableRemoved: aRemovedClassVariable
]

{ #category : #'api - class vars' }
GtClassVariablesDefinition >> renameClassVariableNamed: aCurrentName to: aNewName [
	| aRenamedClassVariable |
	
	(self hasDefinitionNamed: aCurrentName)
		ifFalse: [ self errorClassVariableNotFound: aCurrentName ].
		
	(self hasDefinitionNamed: aNewName)
		ifTrue: [ self errorClassVariableAlreadyExists: aCurrentName ].

	aRenamedClassVariable := self classVariableNamed: aCurrentName.
	aRenamedClassVariable name: aNewName.
	
	self
		notifyClassVariableRenamed: aRenamedClassVariable
		from: aCurrentName
		to: aNewName
]
