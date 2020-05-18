Class {
	#name : #GtCategoryDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'package',
		'tag'
	],
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtCategoryDefinition class >> empty [
	^ self new empty
]

{ #category : #'instance creation' }
GtCategoryDefinition class >> fromBehavior: aBehavior [
	^ self new fromBehavior: aBehavior
]

{ #category : #converting }
GtCategoryDefinition >> asDefinitionString [
	
	^ String streamContents: [ :aStream |
		| aTag |
		aTag := self tag asDefinitionString.
	
		aStream nextPutAll: self package asDefinitionString.
		aTag ifNotEmpty: [
			aStream nextPut: $-.
			aStream nextPutAll: aTag ] ]
]

{ #category : #'gt - editors' }
GtCategoryDefinition >> categoryEditor [
	<return: #GtCodeDefinitionViewer>
	
	^ GtCodeDefinitionCompositeEntityViewer withAll: {
		self package packageEditor.
		self tag tagEditor }
]

{ #category : #'gt - editors' }
GtCategoryDefinition >> categoryReader [
	<return: #GtCodeDefinitionViewer>
	
	^ GtCodeDefinitionCompositeEntityViewer withAll: {
		self package packageReader.
		self tag tagReader }
]

{ #category : #'api - accepting' }
GtCategoryDefinition >> createPackageChange [
	^ tag name notEmpty
		ifTrue: [ RBAddPackageTagChange packageName: package name tagName: tag name ]
		ifFalse: [ RBAddPackageChange packageName: package name ]
]

{ #category : #'api - accepting' }
GtCategoryDefinition >> differenceWith: aCategoryDefinition [
	| aDifference |
	
	self
		assert: [ aCategoryDefinition class = self class ]
		description: [ 'Must be of the same type' ].

	aDifference := GtCategoryDefinitionDifference new.
	aDifference
		oldCategory: self originalName;
		newCategory: self name.

	aDifference packageDifference: (self package differenceWith: aCategoryDefinition package).
	aDifference tagDifference: (self tag differenceWith: aCategoryDefinition tag).

	^ aDifference
]

{ #category : #'gt - editors' }
GtCategoryDefinition >> editors [
	^ { self categoryEditor }
]

{ #category : #initialization }
GtCategoryDefinition >> empty [
	package := GtPackageDefinition empty.	
	tag := GtTagDefinition empty
]

{ #category : #initialization }
GtCategoryDefinition >> fromBehavior: aBehavior [
	package := GtPackageDefinition fromBehavior: aBehavior.	
	tag := GtTagDefinition fromBehavior: aBehavior
]

{ #category : #accessing }
GtCategoryDefinition >> name [
	^ (String streamContents: [ :aStream |
		aStream nextPutAll: self package name.
		self tag name
			ifNotEmpty: [ :aTag |
				aStream
					nextPut: $-;
					nextPutAll: aTag ] ]) asSymbol
]

{ #category : #accessing }
GtCategoryDefinition >> originalName [
	^ (String streamContents: [ :aStream |
		aStream nextPutAll: self package originalName.
		self tag originalName
			ifNotEmpty: [ :aTag |
				aStream
					nextPut: $-;
					nextPutAll: aTag ] ]) asSymbol
]

{ #category : #accessing }
GtCategoryDefinition >> package [
	^ package
]

{ #category : #accessing }
GtCategoryDefinition >> parent: aParent [
	super parent: aParent.
	
	package parent: aParent.
	tag parent: aParent
]

{ #category : #'gt - editors' }
GtCategoryDefinition >> readers [
	^ { self categoryReader }
]

{ #category : #accessing }
GtCategoryDefinition >> tag [
	^ tag
]
