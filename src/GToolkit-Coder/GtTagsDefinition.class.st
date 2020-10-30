Class {
	#name : #GtTagsDefinition,
	#superclass : #GtCompositeDefinition,
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtTagsDefinition class >> fromBehavior: aBehavior [
	^ self new fromBehavior: aBehavior
]

{ #category : #'api - tags' }
GtTagsDefinition >> addTagNamed: aSymbolOrString [
	| aTagName aTagDefinition |
	
	aTagName := aSymbolOrString asSymbol.
	
	(self hasDefinitionNamed: aTagName)
		ifTrue: [ self errorTagAlreadyAdded: aTagName ].
	
	aTagDefinition := GtTagDefinition named: aTagName.
	definitions := definitions copyWith: aTagDefinition.

	self notifyTagAdded: aTagDefinition
]

{ #category : #'private - errors' }
GtTagsDefinition >> errorTagAlreadyAdded: aSymbol [ 
	"Create an error notification that there is already a tag with a given name"

	GtBehaviorCoderHeaderTagAlreadyAddedError signalFor: aSymbol
]

{ #category : #'private - errors' }
GtTagsDefinition >> errorTagNotFound: aSymbol [ 
	"Create an error notification that there is no tag with a given name"

	GtBehaviorCoderHeaderTagNotFoundError signalFor: aSymbol
]

{ #category : #initialization }
GtTagsDefinition >> fromBehavior: aBehavior [
	"traits := aClass traitComposition traits collect: [ :eachTrait | (GtTraitDefinition fromTrait: eachTrait) parent: self ]"
	| aCategoryName aPackageName aTagsString |

	aCategoryName := aBehavior category.
	aPackageName := aBehavior package name.
	
	aTagsString := (aCategoryName beginsWith: aPackageName)
		ifFalse: [ '' ]
		ifTrue: [ aCategoryName allButFirst: aPackageName size ].

	aTagsString := aTagsString trimBoth: [ :aChar | (aChar = $-) or: [ aChar isSeparator ] ].
	
	definitions := ((aTagsString splitOn: '-')
		collect: [ :eachPart | eachPart trimBoth ]
		thenSelect: [ :eachPart | eachPart isNotEmpty ]) collect: [ :eachTagName | GtTagDefinition named: eachTagName ]
]

{ #category : #'private - notifying' }
GtTagsDefinition >> notifyTagAdded: aGtTagDefinition [
	self dispatchEvent: (GtBehaviorTagAdded new
		owner: self parent;
		tag: aGtTagDefinition)
]

{ #category : #'private - notifying' }
GtTagsDefinition >> notifyTagRemoved: aGtTagDefinition [
	self dispatchEvent: (GtBehaviorTagRemoved new
		owner: self parent;
		tag: aGtTagDefinition)
]

{ #category : #'private - notifying' }
GtTagsDefinition >> notifyTagRenamed: aTagDefinition from: anOldName to: aNewName [
	self dispatchEvent: (GtBehaviorTagRenamed new
		owner: self parent;
		tag: aTagDefinition;
		oldName: anOldName;
		newName: aNewName)
]

{ #category : #'api - tags' }
GtTagsDefinition >> removeTagNamed: aSymbol [
	| aRemovedTag |
	
	(self hasDefinitionNamed: aSymbol)
		ifFalse: [ self errorTagNotFound: aSymbol ].
	
	aRemovedTag := self tagNamed: aSymbol.
	definitions := definitions copyWithout: aRemovedTag.
	self notifyTagRemoved: aRemovedTag
]

{ #category : #'api - tags' }
GtTagsDefinition >> renameTagNamed: aCurrentName to: aNewName [
	| aRenamedTag |
	
	(self hasDefinitionNamed: aCurrentName)
		ifFalse: [ self errorTagNotFound: aCurrentName ].

	aRenamedTag := self tagNamed: aCurrentName.
	aRenamedTag name: aNewName.
	
	self
		notifyTagRenamed: aRenamedTag
		from: aCurrentName
		to: aNewName
]

{ #category : #'api - tags' }
GtTagsDefinition >> tagNamed: aSymbol [
	<return: #GtTagDefinition>
	
	^ self
		definitionNamed: aSymbol 
		ifNone: [ self errorTagNotFound: aSymbol ]
]
