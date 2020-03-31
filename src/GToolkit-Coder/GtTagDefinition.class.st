Class {
	#name : #GtTagDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'name'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'instance creation' }
GtTagDefinition class >> fromBehavior: aBehavior [
	^ self new fromBehavior: aBehavior
]

{ #category : #'instance creation' }
GtTagDefinition class >> named: aSymbol [
	^ self new name: aSymbol
]

{ #category : #'gt - editors' }
GtTagDefinition >> editors [
	^ { self tagEditor }
]

{ #category : #'instance creation' }
GtTagDefinition >> fromBehavior: aBehavior [
	| aTagName |
	aTagName := aBehavior category
		copyReplaceAll: aBehavior package name
		with: ''.
	
	aTagName := aTagName trimLeft: [ :aChar | aChar = $- ].
	aTagName := aTagName
		ifEmpty: [ 'Uncategorized' ].
		
	name := aTagName asSymbol
]

{ #category : #accessing }
GtTagDefinition >> name [
	^ name
]

{ #category : #accessing }
GtTagDefinition >> name: aSymbol [
	name := aSymbol asSymbol
]

{ #category : #'gt - editors' }
GtTagDefinition >> tagEditor [
	^ GtCodeDefinitionSingleEditor new
		title: 'Tag';
		definition: self;
		getSelector: #name;
		completion: [ GtPackagesCompletionStrategy new ]
]
