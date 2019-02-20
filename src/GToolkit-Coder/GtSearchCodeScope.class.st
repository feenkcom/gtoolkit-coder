Class {
	#name : #GtSearchCodeScope,
	#superclass : #GtSearchScope,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #enumerating }
GtSearchCodeScope >> classesDo: aBlock [
	self subclassResponsibility
]

{ #category : #ui }
GtSearchCodeScope >> gtViewClassesFor: aView [
	<gtView>
	^ aView list 
		title: 'Classes';
		items: [ |allClasses|
			allClasses := OrderedCollection new.
			self classesDo: [ :aClass | allClasses add: aClass ].
			allClasses ]
]

{ #category : #enumerating }
GtSearchCodeScope >> metaLevelsOf: aClass do: aBlock [
	aBlock value: aClass instanceSide.
	aBlock value: aClass classSide
]

{ #category : #enumerating }
GtSearchCodeScope >> methodsDo: aBlock [
	self classesDo: [ :eachClass | 
		self metaLevelsOf: eachClass do: [ :concreteMetaLevelClass |
			concreteMetaLevelClass methods do: aBlock ] ]
]

{ #category : #enumerating }
GtSearchCodeScope >> packagesDo: aBlock [
	RPackageOrganizer default packages do: aBlock
]
