Class {
	#name : #GtTraitsDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'traits'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'instance creation' }
GtTraitsDefinition class >> fromClass: aClass [
	^ self new fromClass: aClass
]

{ #category : #'instance creation' }
GtTraitsDefinition class >> fromTrait: aTrait [
	^ self new fromTrait: aTrait
]

{ #category : #'api - traits' }
GtTraitsDefinition >> addTraitNamed: aSymbolOrString [
	| aTraitName aTrait aTraitDefinition |
	
	aTraitName := aSymbolOrString asSymbol.
	
	(self hasTraitNamed: aTraitName)
		ifTrue: [ self errorTraitAlreadyAdded: aTraitName ].
		
	(self doesTraitExist: aTraitName)
		ifFalse: [ self errorTraitDoesNotExist: aTraitName ].
	
	aTrait := self class environment at: aTraitName.
	aTraitDefinition := GtTraitDefinition fromTrait: aTrait.
	traits := traits copyWith: aTraitDefinition.

	self notifyTraitAdded: aTraitDefinition
]

{ #category : #accessing }
GtTraitsDefinition >> all [
	^ traits
]

{ #category : #converting }
GtTraitsDefinition >> asDefinitionString [
	self isEmpty
		ifTrue: [ ^ '{}' ].

	^ String streamContents: [ :stream | 
		traits
			do: [ :each | stream nextPutAll: each name ]
			separatedBy: [ stream nextPutAll: ' + ' ].
		stream space ]	
]

{ #category : #accessing }
GtTraitsDefinition >> at: anIndex [
	<return: #GtTraitsDefinition>

	^ traits at: anIndex
]

{ #category : #'api - accepting' }
GtTraitsDefinition >> differenceWith: aGtTraitsDefinition [
	| theDifference |

	theDifference := GtTraitsDefinitionDifference new.

	GtCodeDefinitionDifference
		difference: self all
		with: aGtTraitsDefinition all
		addedDo: [ :eachTrait | theDifference add: (GtTraitAddedToDefinitionDifference new traitName: eachTrait name) ]
		renamedDo: [ :eachTrait |
			theDifference add: (GtTraitRemovedFromDefinitionDifference new traitName: eachTrait originalName).
			theDifference add: (GtTraitAddedToDefinitionDifference new traitName: eachTrait name) ]
		removedDo: [ :eachTrait | theDifference add: (GtTraitRemovedFromDefinitionDifference new traitName: eachTrait name) ].
		
	^ theDifference
]

{ #category : #'api - traits' }
GtTraitsDefinition >> doesTraitExist: aTraitName [
	<return: #Boolean>

	^ self class environment
		at: aTraitName
		ifPresent: [ :aGlobal | aGlobal isTrait ]
		ifAbsent: [ false ]
]

{ #category : #'gt - editors' }
GtTraitsDefinition >> editors [
	^ { self traitsEditor }
]

{ #category : #'private - errors' }
GtTraitsDefinition >> errorTraitAlreadyAdded: aSymbol [ 
	"Create an error notification that there is already a trait with a given name"

	GtBehaviorCoderHeaderTraitAlreadyAddedError signalFor: aSymbol
]

{ #category : #'private - errors' }
GtTraitsDefinition >> errorTraitDoesNotExist: aSymbol [ 
	"Create an error notification that a trait with a given name does not exist in the environment"

	GtBehaviorCoderHeaderTraitDoesNotExistError signalFor: aSymbol
]

{ #category : #'private - errors' }
GtTraitsDefinition >> errorTraitNotFound: aSymbol [ 
	"Create an error notification that there is no trait with a given name"

	GtBehaviorCoderHeaderTraitNotFoundError signalFor: aSymbol
]

{ #category : #initialization }
GtTraitsDefinition >> fromClass: aClass [
	traits := aClass traitComposition traits collect: [ :eachTrait | (GtTraitDefinition fromTrait: eachTrait) parent: self ]
]

{ #category : #initialization }
GtTraitsDefinition >> fromTrait: aTrait [
	traits := aTrait traitComposition traits collect: [ :eachTrait | (GtTraitDefinition fromTrait: eachTrait) parent: self ]
]

{ #category : #'gt-extension' }
GtTraitsDefinition >> gtTraitsFor: aView [
	<gtView>
	
	traits
		ifEmpty: [ ^ aView empty ].
	
	^ aView list
		title: 'Traits';
		priority: 1;
		items: [ traits ]
]

{ #category : #'api - traits' }
GtTraitsDefinition >> hasTraitNamed: aSymbol [
	<return: #Boolean>

	^ traits
		detect: [ :eachTraitDefinition | eachTraitDefinition name = aSymbol ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #initialization }
GtTraitsDefinition >> initialize [
	super initialize.
	
	traits := #()
]

{ #category : #accessing }
GtTraitsDefinition >> isEmpty [
	<return: #Boolean>

	^ self size isZero
]

{ #category : #accessing }
GtTraitsDefinition >> names [
	<return: #Collection of: #Symbol>
	
	^ traits collect: [ :eachTrait | eachTrait name ]
]

{ #category : #'private - notifying' }
GtTraitsDefinition >> notifyTraitAdded: anRGTraitDefinition [
	self dispatchEvent: (GtBehaviorTraitAdded new
		owner: self parent;
		trait: anRGTraitDefinition)
]

{ #category : #'private - notifying' }
GtTraitsDefinition >> notifyTraitRemoved: anRGTraitDefinition [
	self dispatchEvent: (GtBehaviorTraitRemoved new
		owner: self parent;
		trait: anRGTraitDefinition)
]

{ #category : #'private - notifying' }
GtTraitsDefinition >> notifyTraitRenamed: anRGTraitDefinition from: anOldName to: aNewName [
	self dispatchEvent: (GtBehaviorTraitRenamed new
		owner: self parent;
		trait: anRGTraitDefinition;
		oldName: anOldName;
		newName: aNewName)
]

{ #category : #accessing }
GtTraitsDefinition >> parent: aParent [
	super parent: aParent.
	
	traits do: [ :eachTrait | eachTrait parent: aParent ]
]

{ #category : #'api - traits' }
GtTraitsDefinition >> removeTraitNamed: aSymbol [
	| aRemovedTrait |
	
	(self hasTraitNamed: aSymbol)
		ifFalse: [ self errorTraitNotFound: aSymbol ].
	
	aRemovedTrait := self traitNamed: aSymbol.
	traits := traits copyWithout: aRemovedTrait.
	self notifyTraitRemoved: aRemovedTrait
]

{ #category : #'api - traits' }
GtTraitsDefinition >> renameTraitNamed: aCurrentName to: aNewName [
	| aRenamedTrait |
	
	(self hasTraitNamed: aCurrentName)
		ifFalse: [ self errorTraitNotFound: aCurrentName ].

	aRenamedTrait := self traitNamed: aCurrentName.
	aRenamedTrait name: aNewName.
	
	self
		notifyTraitRenamed: aRenamedTrait
		from: aCurrentName
		to: aNewName
]

{ #category : #accessing }
GtTraitsDefinition >> size [
	^ traits size
]

{ #category : #'api - traits' }
GtTraitsDefinition >> traitNamed: aSymbol [
	<return: #GtTraitDefinition>
	
	^ traits
		detect: [ :eachTraitDefinition | eachTraitDefinition name = aSymbol ]
		ifNone: [ self errorTraitNotFound: aSymbol ]
]

{ #category : #'api - traits' }
GtTraitsDefinition >> traitNamed: aSymbol ifFound: aBlock [
	traits
		detect: [ :eachTraitDefinition | eachTraitDefinition name = aSymbol ]
		ifFound: aBlock
]

{ #category : #'gt - editors' }
GtTraitsDefinition >> traitsEditor [
	<return: #GtCodeDefinitionEditor>
	
	^ GtCodeDefinitionPluralEditor new
		definition: self;
		title: 'Traits';
		addSelector: #addTraitNamed:;
		removeSelector: #removeTraitNamed:;
		renameSelector: #renameTraitNamed:to:;
		getSelector: #names;
		addEvent: GtBehaviorTraitAdded;
		removeEvent: GtBehaviorTraitRemoved;
		renameEvent: GtBehaviorTraitRenamed;
		separator: [
			BrLabel new
				look: (BrGlamorousLabelLook new glamorousCodeFont foreground: BrGlamorousColors darkBorderColor );
				text: '+' ];
		completion: [ GtTraitsCompletionStrategy new ]
]
