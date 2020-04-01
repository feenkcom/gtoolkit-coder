Class {
	#name : #GtTagsDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'tags'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'instance creation' }
GtTagsDefinition class >> fromBehavior: aBehavior [
	^ self new fromBehavior: aBehavior
]

{ #category : #'api - tags' }
GtTagsDefinition >> addTagNamed: aSymbolOrString [
	| aTagName aTagDefinition |
	
	aTagName := aSymbolOrString asSymbol.
	
	(self hasTagNamed: aTagName)
		ifTrue: [ self errorTagAlreadyAdded: aTagName ].
	
	aTagDefinition := GtTagDefinition named: aTagName.
	tags := tags copyWith: aTagDefinition.

	self notifyTagAdded: aTagDefinition
]

{ #category : #accessing }
GtTagsDefinition >> all [
	^ tags
]

{ #category : #accessing }
GtTagsDefinition >> at: anIndex [
	<return: #GtTagDefinition>

	^ tags at: anIndex
]

{ #category : #'gt - editors' }
GtTagsDefinition >> editors [
	^ { self tagsEditor }
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
	
	tags := ((aTagsString splitOn: '-')
		collect: [ :eachPart | eachPart trimBoth ]
		thenSelect: [ :eachPart | eachPart isNotEmpty ]) collect: [ :eachTagName | GtTagDefinition named: eachTagName ]
]

{ #category : #ui }
GtTagsDefinition >> gtTagsFor: aView [
	<gtView>
	
	tags
		ifEmpty: [ ^ aView empty ].
	
	^ aView list
		title: 'Tags';
		priority: 1;
		items: [ tags ]
]

{ #category : #'api - tags' }
GtTagsDefinition >> hasTagNamed: aSymbol [
	<return: #Boolean>

	^ tags
		detect: [ :eachTagDefinition | eachTagDefinition name = aSymbol ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #initialization }
GtTagsDefinition >> initialize [
	super initialize.
	
	tags := #()
]

{ #category : #accessing }
GtTagsDefinition >> names [
	<return: #Collection of: #Symbol>
	
	^ tags collect: [ :eachTag | eachTag name ]
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

{ #category : #accessing }
GtTagsDefinition >> parent: aParent [
	super parent: aParent.
	
	tags do: [ :eachTag | eachTag parent: aParent ]
]

{ #category : #'api - tags' }
GtTagsDefinition >> removeTagNamed: aSymbol [
	| aRemovedTag |
	
	(self hasTagNamed: aSymbol)
		ifFalse: [ self errorTagNotFound: aSymbol ].
	
	aRemovedTag := self tagNamed: aSymbol.
	tags := tags copyWithout: aRemovedTag.
	self notifyTagRemoved: aRemovedTag
]

{ #category : #'api - tags' }
GtTagsDefinition >> renameTagNamed: aCurrentName to: aNewName [
	| aRenamedTag |
	
	(self hasTagNamed: aCurrentName)
		ifFalse: [ self errorTagNotFound: aCurrentName ].

	aRenamedTag := self tagNamed: aCurrentName.
	aRenamedTag name: aNewName.
	
	self
		notifyTagRenamed: aRenamedTag
		from: aCurrentName
		to: aNewName
]

{ #category : #accessing }
GtTagsDefinition >> size [
	^ tags size
]

{ #category : #'api - tags' }
GtTagsDefinition >> tagNamed: aSymbol [
	<return: #GtTagDefinition>
	
	^ tags
		detect: [ :eachTagDefinition | eachTagDefinition name = aSymbol ]
		ifNone: [ self errorTagNotFound: aSymbol ]
]

{ #category : #'gt - editors' }
GtTagsDefinition >> tagsEditor [
	<return: #GtCodeDefinitionEditor>
	
	^ GtCodeDefinitionPluralEditor new
		title: 'Tags';
		definition: self;
		addSelector: #addTagNamed:;
		removeSelector: #removeTagNamed:;
		renameSelector: #renameTagNamed:to:;
		getSelector: #names;
		addEvent: GtBehaviorTagAdded;
		removeEvent: GtBehaviorTagRemoved;
		renameEvent: GtBehaviorTagRenamed;
		separator: [
			BrLabel new
				look: (BrGlamorousLabelLook new glamorousCodeFontAndSmallSize foreground: BrGlamorousColors defaultButtonTextColor );
				text: ',' ]
]
