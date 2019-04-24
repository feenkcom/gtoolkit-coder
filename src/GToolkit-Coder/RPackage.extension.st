Extension { #name : #RPackage }

{ #category : #'*GToolkit-Coder' }
RPackage >> usedPackages [
	^ (self usedPackagesByExtending addAll: ((self usedPackagesBySubclassing))) asSet
	
]

{ #category : #'*GToolkit-Coder' }
RPackage >> usedPackagesByExtending [
	^ (self extendedClasses collect: #package) asSet
	
]

{ #category : #'*GToolkit-Coder' }
RPackage >> usedPackagesBySubclassing [
	| selfClasses |
	selfClasses := self classes.
	^ (((selfClasses flatCollect: [ :aClass | aClass withDeep: #superclass collect: [:each | (selfClasses includes: each) ifFalse: [each]]]) select: #isNotNil)) collect: #package.
	
]
