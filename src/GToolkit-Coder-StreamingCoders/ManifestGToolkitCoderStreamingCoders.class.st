"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestGToolkitCoderStreamingCoders,
	#superclass : #PackageManifest,
	#category : #'GToolkit-Coder-StreamingCoders-Manifest'
}

{ #category : #accessing }
ManifestGToolkitCoderStreamingCoders class >> mustOnlyDependOn [
	^ {
		'Announcements-Core'.
		'Collections-Unordered'.
		'Futures'.
		'GToolkit-SearchFilters'.
		'Kernel'
	}
]
