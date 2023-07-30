https://adamtheautomator.com/aws-s3-static-ssl-website/

Yes, you can host multiple static websites from a single Amazon S3 bucket. S3 supports website hosting, and you can configure different paths within the bucket to serve different websites.

Here's how you can set it up:

    Create an S3 bucket: Create a new S3 bucket or use an existing one to store your website files.

    Configure bucket properties: Enable website hosting for the bucket by following these steps:
        Open the Amazon S3 console.
        Select your bucket.
        Go to the "Properties" tab.
        Click on "Static website hosting."
        Choose "Use this bucket to host a website."
        Enter the "Index document" and "Error document" if required.
        Save the changes.

    Upload website files: Upload the files for the first website to the root of the S3 bucket. These files should include an index file (e.g., index.html) that will be served as the entry point for the website.

    Set permissions: Ensure that the objects in your bucket are publicly accessible so that they can be served as web content. You can do this by modifying the bucket's permissions and adding a bucket policy that allows public access. For example, you can set the bucket policy as follows:

    json

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "PublicReadGetObject",
                "Effect": "Allow",
                "Principal": "*",
                "Action": [
                    "s3:GetObject"
                ],
                "Resource": [
                    "arn:aws:s3:::<bucket-name>/*"
                ]
            }
        ]
    }

    Replace <bucket-name> with the name of your S3 bucket.

    Create a folder for the second website: In your S3 bucket, create a new folder (e.g., website2) to hold the files for the second website.

    Upload files for the second website: Upload the files for the second website into the newly created folder.

    Repeat steps 4 and 5 for additional websites: If you have more websites to host, create folders for each website and upload the respective files into those folders.

    Access the websites: To access the websites, you can use the endpoint provided by S3, which will be in the format http://<bucket-name>.s3-website-<AWS-region>.amazonaws.com. Replace <bucket-name> with the name of your S3 bucket and <AWS-region> with the AWS region where your bucket is located.

    For example, if your bucket is named example-bucket and is located in the us-east-1 region, the endpoint would be http://example-bucket.s3-website-us-east-1.amazonaws.com.

    You can access each website by appending the appropriate folder name and file path to the endpoint. For example, to access the second website, use http://example-bucket.s3-website-us-east-1.amazonaws.com/website2/index.html.

By following these steps, you can host multiple static websites from a single S3 bucket. Each website can be accessed using the bucket's endpoint and specifying the appropriate folder and file path.


