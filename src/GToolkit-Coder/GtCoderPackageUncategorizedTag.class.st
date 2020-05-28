Class {
	#name : #GtCoderPackageUncategorizedTag,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'classes',
		'packageTag'
	],
	#category : #'GToolkit-Coder-Navigation - Model'
}

{ #category : #'instance creation' }
GtCoderPackageUncategorizedTag class >> forPackageTag: aRPackage [
	^ self new packageTag: aRPackage.
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
GtCoderPackageUncategorizedTag >> packageTag [
	<return: #RPackageTag>
	^ packageTag
]

{ #category : #accessing }
GtCoderPackageUncategorizedTag >> packageTag: aRPackageTag [
	packageTag := aRPackageTag.
]
