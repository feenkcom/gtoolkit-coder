Class {
	#name : #GtTagDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'name',
		'originalName'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'instance creation' }
GtTagDefinition class >> fromBehavior: aBehavior [
	^ self new fromBehavior: aBehavior
]

{ #category : #'instance creation' }
GtTagDefinition class >> named: aSymbol [
	^ self new
		name: aSymbol;
		originalName: aSymbol
]

{ #category : #converting }
GtTagDefinition >> asDefinitionString [
	^ self name
]

{ #category : #'api - accepting' }
GtTagDefinition >> differenceWith: aTagDefinition [
	<return: #GtCodeDefinitionDifference>
	
	^ self name = aTagDefinition name
		ifTrue: [ GtNoDefinitionDifference new ]
		ifFalse: [ GtTagDefinitionDifference new
			oldName: aTagDefinition name;
			newName: self name ]
]

{ #category : #'gt - editors' }
GtTagDefinition >> editors [
	^ { self tagEditor }
]

{ #category : #initialization }
GtTagDefinition >> fromBehavior: aBehavior [
	| aCategoryName aPackageName aTagString |

	aCategoryName := aBehavior category.
	aPackageName := aBehavior package name.
	
	aTagString := (aCategoryName beginsWith: aPackageName)
		ifFalse: [ '' ]
		ifTrue: [ aCategoryName allButFirst: aPackageName size ].
		
	aTagString := aTagString trimBoth: [ :aChar | (aChar = $-) or: [ aChar isSeparator ] ].

	name := aTagString.
	originalName := aTagString
]

{ #category : #initialization }
GtTagDefinition >> initialize [
	super initialize
]

{ #category : #accessing }
GtTagDefinition >> name [
	^ name
]

{ #category : #accessing }
GtTagDefinition >> name: aSymbol [
	name := aSymbol asSymbol
]

{ #category : #accessing }
GtTagDefinition >> originalName [
	^ originalName
]

{ #category : #accessing }
GtTagDefinition >> originalName: aSymbolOrString [
	originalName := aSymbolOrString asSymbol
]

{ #category : #printing }
GtTagDefinition >> printOn: aStream [
	aStream print: self name
]

{ #category : #'gt - editors' }
GtTagDefinition >> tagEditor [
	^ GtCodeDefinitionSingleEditor new
		title: 'Tag';
		definition: self;
		getSelector: #name;
		setSelector: #name:;
		completion: [ GtPackagesCompletionStrategy new ]
]
