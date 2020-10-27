Class {
	#name : #GtCoderPackageUncategorizedTag,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
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
		(anObject isKindOf: RPackageTag) and: [ self packageTagName = anObject name ] ]
]

{ #category : #accessing }
GtCoderPackageUncategorizedTag >> classes [
	^ self packageTag classes
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
	<return: #RPackageTag>
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
