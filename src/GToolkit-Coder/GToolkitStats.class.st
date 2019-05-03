Class {
	#name : #GToolkitStats,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Dependencies'
}

{ #category : #'as yet unclassified' }
GToolkitStats >> allGToolkitPackages [
	"comment stating purpose of message"

	^ (((GtRlReleaserExportWorkflow buildGToolkitRelease rootProjectRelease project withDeep: #childProjects collect:#yourself) flatCollect: #packages) collect: #asRPackage) select: #isNotNil
]

{ #category : #'as yet unclassified' }
GToolkitStats >> allUsedPackages [
	
	| gtPackages result usedPackages |
	result := Set new.
	gtPackages := self allGToolkitPackages.
	
	gtPackages do: [ :each | 
		usedPackages := each withDeepCollect: #usedPackages.
		usedPackages removeAllFoundIn: gtPackages.
		result addAll: usedPackages].
	^ result
]
