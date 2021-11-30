"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestGToolkitSearchFilters,
	#superclass : #PackageManifest,
	#category : #'GToolkit-SearchFilters-Manifest'
}

{ #category : #accessing }
ManifestGToolkitSearchFilters class >> mustOnlyDependOn [
	^ {
		'Announcements-Core'.
		'Collections-Unordered'.
		'Futures'.
		'Kernel'
	}
]
