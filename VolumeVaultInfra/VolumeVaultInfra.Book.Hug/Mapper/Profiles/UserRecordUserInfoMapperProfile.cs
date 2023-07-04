using AutoMapper;
using FirebaseAdmin.Auth;
using VolumeVaultInfra.Book.Hug.Models;

namespace VolumeVaultInfra.Book.Hug.Mapper.Profiles;

public class UserRecordUserInfoMapperProfile : Profile
{
    public UserRecordUserInfoMapperProfile()
    {
        CreateMap<UserRecord, UserInfo>();
    }
}