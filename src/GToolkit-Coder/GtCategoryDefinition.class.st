Class {
	#name : #GtCategoryDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'package',
		'tag'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'instance creation' }
GtCategoryDefinition class >> fromBehavior: aBehavior [
	^ self new fromBehavior: aBehavior
]

{ #category : #'gt - editors' }
GtCategoryDefinition >> categoryEditor [
	<return: #GtCodeDefinitionEditor>
	
	^ (GtCodeDefinitionCompositeEntityEditor withAll: {
		self package packageEditor.
		self tag tagEditor
	}) title: 'Category'
]

{ #category : #'api - accepting' }
GtCategoryDefinition >> differenceWith: aCategoryDefinition [
	| aDifference |
	
	self
		assert: [ aCategoryDefinition class = self class ]
		description: [ 'Must be of the same type' ].
	
	aDifference := GtCategoryDefinitionDifference new.

	aDifference add: (self package differenceWith: aCategoryDefinition package).
	aDifference add: (self tag differenceWith: aCategoryDefinition tag).

	^ aDifference
]

{ #category : #'gt - editors' }
GtCategoryDefinition >> editors [
	^ { self categoryEditor }
]

{ #category : #initialization }
GtCategoryDefinition >> fromBehavior: aBehavior [
	package := GtPackageDefinition fromBehavior: aBehavior.
	tag := GtTagDefinition fromBehavior: aBehavior
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

{ #category : #accessing }
GtCategoryDefinition >> tag [
	^ tag
]
