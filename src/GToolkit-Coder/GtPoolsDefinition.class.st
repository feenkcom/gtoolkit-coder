Class {
	#name : #GtPoolsDefinition,
	#superclass : #GtCompositeDefinition,
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtPoolsDefinition class >> fromClass: aClass [
	^ self new fromClass: aClass
]

{ #category : #'api - pools' }
GtPoolsDefinition >> addPoolNamed: aSymbolOrString [
	| aPoolName aPool aPoolDefinition |
	
	aPoolName := aSymbolOrString asSymbol.
	
	(self hasDefinitionNamed: aPoolName)
		ifTrue: [ self errorPoolAlreadyAdded: aPoolName ].
		
	(self doesPoolExist: aPoolName)
		ifFalse: [ self errorPoolDoesNotExist: aPoolName ].
	
	aPool := self class environment at: aPoolName.
	aPoolDefinition := GtPoolDefinition fromPool: aPool.
	definitions := definitions copyWith: aPoolDefinition.

	self notifyPoolAdded: aPoolDefinition
]

{ #category : #converting }
GtPoolsDefinition >> asDefinitionString [
	self isEmpty
		ifTrue: [ ^ '' ].

	^ String streamContents: [ :stream | 
		definitions
			do: [ :each | stream nextPutAll: each name ]
			separatedBy: [ stream nextPutAll: ' ' ] ]
]

{ #category : #'api - accepting' }
GtPoolsDefinition >> differenceWith: aGtPoolsDefinition [
	| theDifference |

	theDifference := GtPoolsDefinitionDifference new.

	GtCodeDefinitionDifference
		difference: self all
		with: aGtPoolsDefinition all
		addedDo: [ :eachPool | theDifference add: (GtPoolAddedDifference new poolName: eachPool name) ]
		removedDo: [ :eachPool | theDifference add: (GtPoolRemovedDifference new poolName: eachPool name) ].
		
	^ theDifference
]

{ #category : #'api - pools' }
GtPoolsDefinition >> doesPoolExist: aPoolName [
	<return: #Boolean>

	^ self class environment
		at: aPoolName
		ifPresent: [ :aGlobal | aGlobal isPool ]
		ifAbsent: [ false ]
]

{ #category : #'private - errors' }
GtPoolsDefinition >> errorPoolAlreadyAdded: aSymbol [ 
	"Create an error notification that there is already a pool with a given name"

	GtBehaviorCoderHeaderPoolAlreadyAddedError signalFor: aSymbol
]

{ #category : #'private - errors' }
GtPoolsDefinition >> errorPoolDoesNotExist: aSymbol [ 
	"Create an error notification that a pool with a given name does not exist in the environment"

	GtBehaviorCoderHeaderPoolDoesNotExistError signalFor: aSymbol
]

{ #category : #'private - errors' }
GtPoolsDefinition >> errorPoolNotFound: aSymbol [ 
	"Create an error notification that there is no pool with a given name"

	GtBehaviorCoderHeaderPoolNotFoundError signalFor: aSymbol
]

{ #category : #initialization }
GtPoolsDefinition >> fromClass: aClass [
	definitions := aClass sharedPools collect: [ :eachPool | (GtPoolDefinition fromPool: eachPool) parent: self ]
]

{ #category : #'private - notifying' }
GtPoolsDefinition >> notifyPoolAdded: aGtPoolDefinition [
	self dispatchEvent: (GtBehaviorPoolAdded new
		owner: self parent;
		pool: aGtPoolDefinition)
]

{ #category : #'private - notifying' }
GtPoolsDefinition >> notifyPoolRemoved: aGtPoolDefinition [
	self dispatchEvent: (GtBehaviorPoolRemoved new
		owner: self parent;
		pool: aGtPoolDefinition)
]

{ #category : #'private - notifying' }
GtPoolsDefinition >> notifyPoolRenamed: aGtPoolDefinition from: anOldName to: aNewName [
	self dispatchEvent: (GtBehaviorPoolRenamed new
		owner: self parent;
		pool: aGtPoolDefinition;
		oldName: anOldName;
		newName: aNewName)
]

{ #category : #'api - pools' }
GtPoolsDefinition >> poolNamed: aSymbol [
	<return: #GtPoolDefinition>
	
	^ self
		definitionNamed: aSymbol 
		ifNone: [ self errorPoolNotFound: aSymbol ]
]

{ #category : #'api - pools' }
GtPoolsDefinition >> removePoolNamed: aSymbol [
	| aRemovedPool |
	
	(self hasDefinitionNamed: aSymbol)
		ifFalse: [ self errorPoolNotFound: aSymbol ].
	
	aRemovedPool := self poolNamed: aSymbol.
	definitions := definitions copyWithout: aRemovedPool.
	self notifyPoolRemoved: aRemovedPool
]

{ #category : #'api - pools' }
GtPoolsDefinition >> renamePoolNamed: aCurrentName to: aNewName [
	| aRenamedPool |
	
	(self hasDefinitionNamed: aCurrentName)
		ifFalse: [ self errorPoolNotFound: aCurrentName ].
		
	(self hasDefinitionNamed: aNewName)
		ifTrue: [ self errorPoolAlreadyAdded: aCurrentName ].

	aRenamedPool := self poolNamed: aCurrentName.
	aRenamedPool name: aNewName.
	
	self
		notifyPoolRenamed: aRenamedPool
		from: aCurrentName
		to: aNewName
]
