output out_public_ip_addresses {
  value = aws_instance.assessment-instance.*.public_ip
}

output out_private_ip_addresses {
  value = aws_instance.assessment-instance.*.private_ip
}
