Class {
	#name : #GToolkitStats,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Dependencies'
}

{ #category : #'as yet unclassified' }
GToolkitStats >> allExternalSuperclasses [
	
	"comment stating purpose of message"
	
	| allClasses|
	allClasses := self allGToolkitClasses.
	^ ((allClasses flatCollect: [ :aClass | aClass withDeep: #superclass collect: [:each | (allClasses includes: each) ifFalse: [each]]]) select: #isNotNil) removeDuplicates.
]

{ #category : #'as yet unclassified' }
GToolkitStats >> allGToolkitClasses [
	"comment stating purpose of message"

	^ ((((GtRlReleaserExportWorkflow buildGToolkitRelease rootProjectRelease project withDeep: #childProjects collect:#yourself) flatCollect: #packages) collect: #asRPackage) select: #isNotNil) flatCollect: #classes
]

{ #category : #'as yet unclassified' }
GToolkitStats >> allMethods [
	
	^ self allGToolkitClasses flatCollect: #methods
]
