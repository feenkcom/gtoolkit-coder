Class {
	#name : #GtCoderPackageUncategorizedTag,
	#superclass : #Object,
	#instVars : [
		'packageTag'
	],
	#category : #'GToolkit-Coder-Navigation - Model'
}

{ #category : #'instance creation' }
GtCoderPackageUncategorizedTag class >> forPackageTag: aRPackage [
	^ self new packageTag: aRPackage.
]

{ #category : #comparing }
GtCoderPackageUncategorizedTag >> = anObject [
	^ (self class = anObject class and: [ self packageTagName = anObject packageTagName ]) or: [
		(anObject isPharoPackageTagModel) and: [ self packageTagName = anObject name ] ]
]

{ #category : #accessing }
GtCoderPackageUncategorizedTag >> categoryName [
	^ packageTag categoryName
]

{ #category : #accessing }
GtCoderPackageUncategorizedTag >> classes [
	^ self packageTag classes
]

{ #category : #accessing }
GtCoderPackageUncategorizedTag >> gtTagName [
	^ packageTag name
]

{ #category : #testing }
GtCoderPackageUncategorizedTag >> isRoot [
	^ true
]

{ #category : #accessing }
GtCoderPackageUncategorizedTag >> isUncategorized [
	^ true
]

{ #category : #accessing }
GtCoderPackageUncategorizedTag >> name [
	^ 'Uncategorized'
]

{ #category : #accessing }
GtCoderPackageUncategorizedTag >> package [
	^ self packageTag package
]

{ #category : #accessing }
GtCoderPackageUncategorizedTag >> packageName [
	^ self package name
]

{ #category : #accessing }
GtCoderPackageUncategorizedTag >> packageTag [
	<return: #PackageTag>
	^ packageTag
]

{ #category : #accessing }
GtCoderPackageUncategorizedTag >> packageTag: aRPackageTag [
	packageTag := aRPackageTag.
]

{ #category : #accessing }
GtCoderPackageUncategorizedTag >> packageTagName [
	<return: #String>
	^ self packageTag name
]
