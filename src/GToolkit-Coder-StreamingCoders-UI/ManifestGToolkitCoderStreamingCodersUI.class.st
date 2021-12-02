"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestGToolkitCoderStreamingCodersUI,
	#superclass : #PackageManifest,
	#category : #'GToolkit-Coder-StreamingCoders-UI-Manifest'
}

{ #category : #accessing }
ManifestGToolkitCoderStreamingCodersUI class >> mustOnlyDependOn [
	^ {
		'Announcements-Core'.
		'Collections-Sequenceable'.
		'Futures'.
		'GToolkit-Coder-StreamingCoders'.
		'Kernel'
	}
]

{ #category : #accessing }
ManifestGToolkitCoderStreamingCodersUI class >> shouldDependOn [
	^ {
		'Futures'.
		'GToolkit-Coder-StreamingCoders'.
	}
]
